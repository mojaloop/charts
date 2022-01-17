import got, { Method, OptionsOfJSONResponseBody } from 'got';
import { components } from './types/role_assignment';
import {
    roleAssignmentSvcBasePath,
    mlIngressBasePath,
    username,
    password,
} from './config';
import login from './login';

type Users = components["schemas"]["UsersGetResponse"];
type User = components["schemas"]["User"];
type Roles = components["schemas"]["UsersIDRolesGetResponse"];
type Role = Roles["roles"][0];
type RolePatch = components["schemas"]["UsersIDRolesPatchRequest"];

interface TestParameters {
    role: Role;
    url: URL;
    method: Method;
}

const GOT_JSON_OPTS: OptionsOfJSONResponseBody = {
    isStream: false,
    resolveBodyOnly: false,
    responseType: 'json',
    throwHttpErrors: false,
    headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
    },
};

async function clearUserRoles(id: User["id"]) {
    const response = await got.get<Roles>(
        `${roleAssignmentSvcBasePath}/users/${id}/roles`,
        GOT_JSON_OPTS,
    );
    expect(response.statusCode).toEqual(200);
    if (response.body.roles.length > 0) {
        const body: RolePatch = {
            roleOperations: response.body.roles.map((role) => ({
                roleId: role,
                action: 'delete',
            })),
        }
        await got.patch<null>(`${roleAssignmentSvcBasePath}/users/${id}/roles`, {
            ...GOT_JSON_OPTS,
            body: JSON.stringify(body),
        });
        expect(response.statusCode).toEqual(200);
    }
}

async function appendUserRole(id: User["id"], role: Role) {
    const body: RolePatch = {
        roleOperations: [{
            roleId: role,
            action: 'delete',
        }],
    }
    await got.patch<null>(`${roleAssignmentSvcBasePath}/users/${id}/roles`, {
        ...GOT_JSON_OPTS,
        body: JSON.stringify(body),
    });
}

let testUser: User;

beforeAll(async () => {
    const response = await got.get<Users>(`${roleAssignmentSvcBasePath}/users`, GOT_JSON_OPTS);
    expect(response.statusCode).toEqual(200);
    const user = response.body.users?.find((user: User) => user.username === username);
    expect(user?.id).toBeDefined();
    testUser = user!;
});

beforeEach(async () => {
    await clearUserRoles(testUser.id);
})

afterAll(async () => {
    await clearUserRoles(testUser.id);
});

const deny: TestParameters[] = [
    {
        url: new URL(`/settlements/`, mlIngressBasePath),
        method: 'POST',
        role: 'USER_ROLE',
    },
]

const allow: TestParameters[] = [
    {
        url: new URL(`/settlements/`, mlIngressBasePath),
        method: 'POST',
        role: 'ADMIN_ROLE',
    },
]

test.each(allow)(
    'Test user with role $role is allowed access to $method $url',
    async ({ url, method, role }) => {
        await appendUserRole(testUser.id, role);
        const { cookieJar } = await login(username, password, mlIngressBasePath);
        const response = await got({
            method,
            url,
            throwHttpErrors: false,
            cookieJar,
        });
        // TODO: what status codes are we actually expecting?
        expect([401, 403]).not.toContain(response.statusCode);
    },
);

test.each(deny)(
    'Test user with role $role is denied access to $method $url',
    async ({ url, method, role }) => {
        await appendUserRole(testUser.id, role);
        const { cookieJar } = await login(username, password, mlIngressBasePath);
        const response = await got({
            method,
            url,
            throwHttpErrors: false,
            cookieJar,
        });
        // TODO: what status codes are we actually expecting?
        expect([401, 403]).toContain(response.statusCode);
    },
);
