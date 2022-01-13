import * as env from 'env-var';

export const roleAssignmentSvcBasePath = env.get('ROLE_ASSIGNMENT_SVC_BASE_PATH')
    .default('http://localhost:3008')
    .asUrlObject();

export const mlIngressBasePath = env.get('ML_INGRESS_BASE_PATH')
    .default('http://localhost:8000')
    .asUrlObject();

export const testUserName = env.get('TEST_USER_NAME')
    .default('test1')
    .asString();
