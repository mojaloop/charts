import * as env from 'env-var';

export const roleAssignmentSvcBasePath = env.get('ROLE_ASSIGNMENT_SVC_BASE_PATH')
    .default('http://localhost:3008')
    .asUrlObject();

// It's useful to parse this as a URL object for validation. But any query strings will be
// discarded, only the origin and path will be used.
const basePathUrl = env.get('ML_INGRESS_BASE_PATH')
    .default('http://bofportal.test.infra.mojatest.live.internal')
    .asUrlObject();
export const mlIngressBasePath = `${basePathUrl.origin}${basePathUrl.pathname}`.replace(/\/*$/, '');

export const username = env.get('TEST_USER_NAME')
    .default('portaladmin')
    .asString();

export const password = env.get('TEST_USER_PASSWORD')
    .default('81G6g8aAfsI4kFwcU3jK7X3FRDtNu8')
    .asString();
