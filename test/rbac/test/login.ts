import { strict as assert } from 'assert';
import got from 'got';
import { URL, URLSearchParams } from 'url';

function extractCookieValue(cookies: string[] | undefined, name: string): string | undefined {
    const replaceRe = new RegExp(`${name}\\s*=`);
    return cookies?.find((c) => c.includes(name))?.split(';').find((c) => c.includes(name))?.replace(replaceRe, '').trim();
};

export default async function login(username: string, password: string, basePath: string) {

    // TODO:
    // - Try to use cookieJar? I guess it's emulating the behaviour of the browser. It's not like js
    //   normally sets cookies anyway- though we'd probably have to check the cookie parameters are
    //   correct for this; e.g. HttpOnly; Secure; (I think..)
    //   https://github.com/sindresorhus/got/blob/main/documentation/2-options.md#cookiejar
    // - set throwHttpErrors to true for everything except /whoami ?

    // This will fail and return a 401, but we'll get the CSRF token from it
    const whoami = await got(`${basePath}/kratos/sessions/whoami`, {
        headers: {
            "accept": "application/json, text/plain, */*",
            "accept-language": "en-GB,en;q=0.9",
            "Referer": `${basePath}/`,
            "Referrer-Policy": "strict-origin-when-cross-origin"
        },
        method: 'GET',
        throwHttpErrors: false,
    })

    const cookie = whoami.headers['set-cookie'];
    const csrfToken = extractCookieValue(cookie, 'csrf_token');
    assert(csrfToken, 'Need cookie');

    const browser = await got(`${basePath}/kratos/self-service/registration/browser`, {
        "headers": {
            cookie,
            "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "accept-language": "en-GB,en;q=0.9",
            "upgrade-insecure-requests": "1"
        },
        "method": "GET",
        throwHttpErrors: false,
        followRedirect: false,
    });

    console.log(browser.statusCode);
    console.log(browser.headers);
    assert.equal(browser.statusCode, 302, 'Expected 302');
    assert(browser.headers.location, 'Need to know where we were redirected');
    const locationUrl = new URL(browser.headers.location);

    const flow = locationUrl.searchParams.get('flow');
    assert(flow, 'Need flow ID');

    // Probably don't need to do this; we get a text/html response and no useful headers from it
    const formPage = await got(locationUrl, {
        "headers": {
            "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "accept-language": "en-GB,en;q=0.9",
            "upgrade-insecure-requests": "1",
            "Referer": `${basePath}/`,
            "Referrer-Policy": "strict-origin-when-cross-origin"
        },
        "method": "GET",
        throwHttpErrors: false,
        followRedirect: false,
    });

    // TODO: HTML parse, then use .querySelector, instead of brittle, syntax-unaware regex match
    console.log(formPage.statusCode);
    const lines = formPage.body.split('\n');
    const valueRe = /value\s*=\s*"[^"]+/g;
    const body_csrf_token = lines.find((l) => /input name="csrf_token"/.test(l))?.trim().matchAll(valueRe).next().value[0].replace(/value\s*=\s*"/, '');
    const body_provider = lines.find((l) => /input name="provider"/.test(l))?.trim().matchAll(valueRe).next().value[0].replace(/value\s*=\s*"/, '');
    console.log(body_csrf_token, body_provider);
    const bodyParams = new URLSearchParams({ csrf_token: body_csrf_token, provider: body_provider });
    console.log(bodyParams.toString());
    assert(body_csrf_token, 'csrf_token extracted from form page required to proceed');
    assert(body_provider, 'provider extracted from form page required to proceed');

    const auth = await got(`${basePath}/kratos/self-service/methods/oidc/auth/${flow}`, {
      "headers": {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "accept-language": "en-GB,en;q=0.9",
        "cache-control": "max-age=0",
        "content-type": "application/x-www-form-urlencoded",
        cookie,
      },
      body: bodyParams.toString(),
      throwHttpErrors: false,
      followRedirect: false,
      "method": "POST"
    });

    console.log(auth.statusCode);
    assert.equal(auth.statusCode, 302, 'Expected to receive a redirect to authorize');
    console.log(auth.headers);
    assert(auth.headers.location, 'Expected to receive redirect location for authorize');
    assert(auth.headers['set-cookie'], 'Expected cookie to be set');
    const authorizeUrl = new URL(auth.headers.location);
    const kratosContinuityCookie = extractCookieValue(auth.headers['set-cookie'], 'ory_kratos_continuity');

    // await fetch("https://iskmssl.test.infra.mojatest.live:7443/oauth2/authorize?client_id=4JIfnDEaEPIv187prC_nmHIfvpQa&redirect_uri=http%3A%2F%2Fbofportal.test.infra.mojatest.live.internal%2Fkratos%2Fself-service%2Fmethods%2Foidc%2Fcallback%2Fidp&response_type=code&scope=openid&state=59861885-22e4-4b3a-90ac-ed3c10f4f7b1", {
    const authorize = await got(authorizeUrl, {
      "headers": {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "accept-language": "en-GB,en;q=0.9",
        // "cache-control": "max-age=0",
        // "sec-ch-ua": "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"96\"",
        // "sec-ch-ua-mobile": "?0",
        // "sec-ch-ua-platform": "\"Linux\"",
        // "sec-fetch-dest": "document",
        // "sec-fetch-mode": "navigate",
        // "sec-fetch-site": "cross-site",
        // "upgrade-insecure-requests": "1",
        // "Referer": `${basePath}/`,
        // "Referrer-Policy": "strict-origin-when-cross-origin",
        // cookie: kratosContinuityCookie,
      },
      // "body": null,
      "method": "GET",
      throwHttpErrors: false,
      followRedirect: false,
    });

    console.log(authorize.statusCode);
    assert.equal(authorize.statusCode, 302, 'Expected to receive a redirect to login');
    console.log(authorize.headers);
    assert(authorize.headers.location, 'Expected to receive redirect location for login');
    const loginUrl = new URL(authorize.headers.location);
    const sessionDataKey = loginUrl.searchParams.get('sessionDataKey');
    assert(sessionDataKey, 'Need to extract session data key from login redirect URL');

    // Skip this because it just returns us our login page
    // await fetch("https://iskmssl.test.infra.mojatest.live:7443/authenticationendpoint/login.do?client_id=4JIfnDEaEPIv187prC_nmHIfvpQa&commonAuthCallerPath=%2Foauth2%2Fauthorize&forceAuth=false&passiveAuth=false&redirect_uri=http%3A%2F%2Fbofportal.test.infra.mojatest.live.internal%2Fkratos%2Fself-service%2Fmethods%2Foidc%2Fcallback%2Fidp&response_type=code&scope=openid&state=59861885-22e4-4b3a-90ac-ed3c10f4f7b1&tenantDomain=carbon.super&sessionDataKey=21482d7f-b066-4da9-aca6-93dc52e883ee&relyingParty=4JIfnDEaEPIv187prC_nmHIfvpQa&type=oidc&sp=BOF_portal&isSaaSApp=false&authenticators=BasicAuthenticator:LOCAL", {
    //   "headers": {
    //     "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    //     "accept-language": "en-GB,en;q=0.9",
    //     "cache-control": "max-age=0",
    //     "sec-ch-ua": "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"96\"",
    //     "sec-ch-ua-mobile": "?0",
    //     "sec-ch-ua-platform": "\"Linux\"",
    //     "sec-fetch-dest": "document",
    //     "sec-fetch-mode": "navigate",
    //     "sec-fetch-site": "cross-site",
    //     "upgrade-insecure-requests": "1",
    //     "Referer": `${basePath}/`,
    //     "Referrer-Policy": "strict-origin-when-cross-origin"
    //   },
    //   "body": null,
    //   "method": "GET"
    // });

    // This doesn't seem to do anything for us
    // await fetch("https://iskmssl.test.infra.mojatest.live:7443/logincontext?sessionDataKey=21482d7f-b066-4da9-aca6-93dc52e883ee&relyingParty=4JIfnDEaEPIv187prC_nmHIfvpQa&tenantDomain=carbon.super", {
    //   "headers": {
    //     "accept": "*/*",
    //     "accept-language": "en-GB,en;q=0.9",
    //     "sec-ch-ua": "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"96\"",
    //     "sec-ch-ua-mobile": "?0",
    //     "sec-ch-ua-platform": "\"Linux\"",
    //     "sec-fetch-dest": "empty",
    //     "sec-fetch-mode": "cors",
    //     "sec-fetch-site": "same-origin",
    //     "x-requested-with": "XMLHttpRequest",
    //     "Referer": "https://iskmssl.test.infra.mojatest.live:7443/authenticationendpoint/login.do?client_id=4JIfnDEaEPIv187prC_nmHIfvpQa&commonAuthCallerPath=%2Foauth2%2Fauthorize&forceAuth=false&passiveAuth=false&redirect_uri=http%3A%2F%2Fbofportal.test.infra.mojatest.live.internal%2Fkratos%2Fself-service%2Fmethods%2Foidc%2Fcallback%2Fidp&response_type=code&scope=openid&state=59861885-22e4-4b3a-90ac-ed3c10f4f7b1&tenantDomain=carbon.super&sessionDataKey=21482d7f-b066-4da9-aca6-93dc52e883ee&relyingParty=4JIfnDEaEPIv187prC_nmHIfvpQa&type=oidc&sp=BOF_portal&isSaaSApp=false&authenticators=BasicAuthenticator:LOCAL",
    //     "Referrer-Policy": "strict-origin-when-cross-origin"
    //   },
    //   "body": null,
    //   "method": "GET"
    // });

    // const username = 'portaladmin';
    // const password = '81G6g8aAfsI4kFwcU3jK7X3FRDtNu8';

    const bodyParamsCredentials = new URLSearchParams({
        username,
        password,
        sessionDataKey,
    });
    console.log('body creds');
    console.log(bodyParamsCredentials.toString());
    // TODO: we need to get the ISKM URL from one of the redirects above, I _think_
    const commonAuth = await got("https://iskmssl.test.infra.mojatest.live:7443/commonauth", {
      "headers": {
        // "Referer": "https://iskmssl.test.infra.mojatest.live:7443/authenticationendpoint/login.do?client_id=4JIfnDEaEPIv187prC_nmHIfvpQa&commonAuthCallerPath=%2Foauth2%2Fauthorize&forceAuth=false&passiveAuth=false&redirect_uri=http%3A%2F%2Fbofportal.test.infra.mojatest.live.internal%2Fkratos%2Fself-service%2Fmethods%2Foidc%2Fcallback%2Fidp&response_type=code&scope=openid&state=59861885-22e4-4b3a-90ac-ed3c10f4f7b1&tenantDomain=carbon.super&sessionDataKey=21482d7f-b066-4da9-aca6-93dc52e883ee&relyingParty=4JIfnDEaEPIv187prC_nmHIfvpQa&type=oidc&sp=BOF_portal&isSaaSApp=false&authenticators=BasicAuthenticator:LOCAL",
        "Referer": loginUrl.toString(),
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "accept-language": "en-GB,en;q=0.9",
        // "cache-control": "max-age=0",
        "content-type": "application/x-www-form-urlencoded",
        // "sec-ch-ua": "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"96\"",
        // "sec-ch-ua-mobile": "?0",
        // "sec-ch-ua-platform": "\"Linux\"",
        // "sec-fetch-dest": "document",
        // "sec-fetch-mode": "navigate",
        // "sec-fetch-site": "same-origin",
        // "sec-fetch-user": "?1",
        // "upgrade-insecure-requests": "1",
        // "Referrer-Policy": "strict-origin-when-cross-origin"
      },
      body: bodyParamsCredentials.toString(),
      // "body": "username=paulbaker&password=bxmH2aZRUJXsclHMa9XSUYAXfk52tP&sessionDataKey=21482d7f-b066-4da9-aca6-93dc52e883ee",
      "method": "POST",
      throwHttpErrors: false,
      followRedirect: false,
    });

    console.log(commonAuth.statusCode);
    assert.equal(commonAuth.statusCode, 302, 'Expected to receive a redirect to authorize');
    console.log(commonAuth.headers);
    assert(commonAuth.headers.location, 'Expected to receive redirect location for authorize');
    assert(commonAuth.headers['set-cookie'], 'Expected cookies to be set');
    const authorizeUrl2 = new URL(commonAuth.headers.location);
    const commonAuthIdCookie = extractCookieValue(commonAuth.headers['set-cookie'], 'commonAuthId');
    assert(commonAuthIdCookie, 'Need commonAuthId cookie to proceed');

    // await fetch("https://iskmssl.test.infra.mojatest.live:7443/oauth2/authorize?sessionDataKey=6490be27-ad73-4c78-bff4-9eede5e5ffb6", {
    const authorize2 = await got(authorizeUrl2, {
      "headers": {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "accept-language": "en-GB,en;q=0.9",
        // "cache-control": "max-age=0",
        // "sec-ch-ua": "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"96\"",
        // "sec-ch-ua-mobile": "?0",
        // "sec-ch-ua-platform": "\"Linux\"",
        // "sec-fetch-dest": "document",
        // "sec-fetch-mode": "navigate",
        // "sec-fetch-site": "same-origin",
        // "sec-fetch-user": "?1",
        // "upgrade-insecure-requests": "1",
        "cookie": `commonAuthId=${commonAuthIdCookie}`,
        // "Referer": "https://iskmssl.test.infra.mojatest.live:7443/authenticationendpoint/login.do?client_id=4JIfnDEaEPIv187prC_nmHIfvpQa&commonAuthCallerPath=%2Foauth2%2Fauthorize&forceAuth=false&passiveAuth=false&redirect_uri=http%3A%2F%2Fbofportal.test.infra.mojatest.live.internal%2Fkratos%2Fself-service%2Fmethods%2Foidc%2Fcallback%2Fidp&response_type=code&scope=openid&state=59861885-22e4-4b3a-90ac-ed3c10f4f7b1&tenantDomain=carbon.super&sessionDataKey=21482d7f-b066-4da9-aca6-93dc52e883ee&relyingParty=4JIfnDEaEPIv187prC_nmHIfvpQa&type=oidc&sp=BOF_portal&isSaaSApp=false&authenticators=BasicAuthenticator:LOCAL",
        // "Referrer-Policy": "strict-origin-when-cross-origin"
      },
      // "body": null,
      "method": "GET",
      throwHttpErrors: false,
      followRedirect: false,
    });

    console.log(authorize2.statusCode);
    assert.equal(authorize2.statusCode, 302, 'Expected to receive a redirect to authorize');
    console.log(authorize2.headers);
    assert(authorize2.headers.location, 'Expected to receive redirect location for authorize');
    const idpCallbackUrl = new URL(authorize2.headers.location);

    // await fetch(`${basePath}/kratos/self-service/methods/oidc/callback/idp?code=398b1182-552b-3e97-bf5d-d1c016f33715&state=59861885-22e4-4b3a-90ac-ed3c10f4f7b1&session_state=859e1356ddfd3a5db6a715d1fd8ca4c02c8f43bdebab757d8926b40107994857.wn06dbrgO7RuAepA5xVKtA`, {
    const idp = await got(idpCallbackUrl, {
        "headers": {
            "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "accept-language": "en-GB,en;q=0.9",
            cookie: `csrf_token=${csrfToken}; ory_kratos_continuity=${kratosContinuityCookie}`
            // "cache-control": "max-age=0",
            // "upgrade-insecure-requests": "1",
            // "cookie": "csrf_token=/7iqpr7GFjOiUCFheYXCYCTPn0Ix44FsX0A/W549+Pk=; ory_kratos_continuity=MTY0MjE2ODg0OHxEdi1CQkFFQ180SUFBUkFCRUFBQVhfLUNBQUVHYzNSeWFXNW5EQ01BSVc5eWVWOXJjbUYwYjNOZmIybGtZMTloZFhSb1gyTnZaR1ZmYzJWemMybHZiZ1p6ZEhKcGJtY01KZ0FrWW1GaE5HVTJORE10TjJVellpMDBZakJpTFdKall6UXRZemxsWVRFNFpXTmpPR0l5fAp3jXr3grSSgektVLBTCu18x5s7W6aIoy2PnrpeeFqn"
        },
        // "referrerPolicy": "strict-origin-when-cross-origin",
        // "body": null,
        "method": "GET",
        throwHttpErrors: false,
        followRedirect: false,
    });

    console.log(idp.statusCode);
    console.log(idp.headers);
    // const authorizeUrl2 = new URL(idp.headers.location);
    const continuity = extractCookieValue(idp.headers['set-cookie'], 'ory_kratos_continuity');
    const session = extractCookieValue(idp.headers['set-cookie'], 'ory_kratos_session');
    const csrf = extractCookieValue(idp.headers['set-cookie'], 'csrf_token');
    assert(continuity, 'Need ory_kratos_continuity cookie to proceed');
    assert(session, 'Need ory_kratos_session cookie to proceed');
    assert(csrf, 'Need csrf_token cookie to proceed');

    // Nothing useful retrieved from this, I _think_
    // await fetch(`${basePath}/`, {
    //   "headers": {
    //     "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    //     "accept-language": "en-GB,en;q=0.9",
    //     "cache-control": "max-age=0",
    //     "if-modified-since": "Mon, 10 Jan 2022 12:47:19 GMT",
    //     "if-none-match": "\"61dc2ad7-2f4\"",
    //     "upgrade-insecure-requests": "1",
    //     "cookie": "ory_kratos_continuity=MTY0MjE2ODg3NHxEdi1CQkFFQ180SUFBUkFCRUFBQUJQLUNBQUE9fH4-0t1xCV1p1BnnIgHTay6cOda8iHBfo9es4lBamhKk; ory_kratos_session=MTY0MjE2ODg3NHxEdi1CQkFFQ180SUFBUkFCRUFBQVJfLUNBQUVHYzNSeWFXNW5EQThBRFhObGMzTnBiMjVmZEc5clpXNEdjM1J5YVc1bkRDSUFJSGRaTTB0S09WaEtVblZ5ZEVWRlNtdG1jSGQ2VWxCbU1VZFBjbTVQZUdweHxjRpDP-ZRYGlUgJgxRIygrYyW6NOci8TWMaBS8tjY8OA=="
    //   },
    //   "referrerPolicy": "strict-origin-when-cross-origin",
    //   "body": null,
    //   "method": "GET"
    // });

    const whoamiSuccess = await got(`${basePath}/kratos/sessions/whoami`, {
        "headers": {
            "accept": "application/json, text/plain, */*",
            "accept-language": "en-GB,en;q=0.9",
            // "cookie": "csrf_token=vg6Un8IxT1nXnxpWi9ls7DXoqovmEKx/XvDtJ9vBAVY=; ory_kratos_continuity=MTY0MjE2ODg3NHxEdi1CQkFFQ180SUFBUkFCRUFBQUJQLUNBQUE9fH4-0t1xCV1p1BnnIgHTay6cOda8iHBfo9es4lBamhKk; ory_kratos_session=MTY0MjE2ODg3NHxEdi1CQkFFQ180SUFBUkFCRUFBQVJfLUNBQUVHYzNSeWFXNW5EQThBRFhObGMzTnBiMjVmZEc5clpXNEdjM1J5YVc1bkRDSUFJSGRaTTB0S09WaEtVblZ5ZEVWRlNtdG1jSGQ2VWxCbU1VZFBjbTVQZUdweHxjRpDP-ZRYGlUgJgxRIygrYyW6NOci8TWMaBS8tjY8OA==",
            "cookie": `csrf_token=${csrf}; ory_kratos_continuity=${continuity}; ory_kratos_session=${session}`,
            // "Referer": `${basePath}/`,
            // "Referrer-Policy": "strict-origin-when-cross-origin"
        },
        // "body": null,
        "method": "GET"
    });

    assert.equal(whoamiSuccess.statusCode, 200, 'Whoami failed');

    return JSON.parse(whoamiSuccess.body);
}
