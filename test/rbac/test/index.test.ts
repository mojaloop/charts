import got, { OptionsOfJSONResponseBody } from 'got';
import { components } from 'types/role_assignment';

type Users = components["schemas"]["UsersGetResponse"];
type User = components["schemas"]["User"];
type Role = string;


interface TestParameters {
    roles: Role[];

}

const basePath = 'http://localhost:3008';
const testUserName = 'test1';

describe('nothing', () => {
    let testUserId: User["id"];
    beforeAll(async () => {
        const response = await got.get<Users>(`${basePath}/users`);
        expect(response.statusCode).toEqual(200);
        console.log(response.body);
        const user = response.body.users?.find((user) => user.name === testUserName);
        expect(user?.id).toBeDefined();
        testUserId = user!.id;
    });
    test('whatever', () => {
        console.log(testUserId);
        expect(true);
    });
});
