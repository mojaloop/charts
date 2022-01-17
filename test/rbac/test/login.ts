// This code was created as follows:
// 1. open an empty browser page/tab
// 2. open developer tools, network tab
// 3. choose "Preserve Log"
// 4. navigate to BOF login
// 5. log in using valid credentials
// 6. reproduce the observed network traffic here to login and retrieve session token etc.
//
// If problems are encountered, comparing the behaviour of login against the behaviour of this code
// might be prudent.

import { strict as assert } from 'assert';
import got from 'got';
import { URL, URLSearchParams } from 'url';
import { parse } from 'node-html-parser';

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

    // This should fail and return a 401, but we'll get the CSRF token from it
    const whoami = await got(`${basePath}/kratos/sessions/whoami`, {
        headers: {
            "accept": "application/json, text/plain, */*",
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
        },
        "method": "GET",
        throwHttpErrors: false,
        followRedirect: false,
    });

    assert.equal(browser.statusCode, 302, 'Expected 302');
    assert(browser.headers.location, 'Need to know where we were redirected');
    const locationUrl = new URL(browser.headers.location);

    const flow = locationUrl.searchParams.get('flow');
    assert(flow, 'Need flow ID');

    const formPage = await got(locationUrl, {
        "headers": {
            "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "Referer": `${basePath}/`,
        },
        "method": "GET",
        throwHttpErrors: false,
        followRedirect: false,
    });
    const html = parse(formPage.body);
    const body_csrf_token = html.querySelector('input[name="csrf_token"]')?.attrs.value;
    const body_provider = html.querySelector('input[name="provider"]')?.attrs.value;
    assert(body_csrf_token, 'csrf_token extracted from form page required to proceed');
    assert(body_provider, 'provider extracted from form page required to proceed');
    const bodyParams = new URLSearchParams({ csrf_token: body_csrf_token, provider: body_provider });

    const auth = await got(`${basePath}/kratos/self-service/methods/oidc/auth/${flow}`, {
      "headers": {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "content-type": "application/x-www-form-urlencoded",
        cookie,
      },
      body: bodyParams.toString(),
      throwHttpErrors: false,
      followRedirect: false,
      "method": "POST"
    });

    assert.equal(auth.statusCode, 302, 'Expected to receive a redirect to authorize');
    assert(auth.headers.location, 'Expected to receive redirect location for authorize');
    assert(auth.headers['set-cookie'], 'Expected cookie to be set');
    const authorizeUrl = new URL(auth.headers.location);
    const kratosContinuityCookie = extractCookieValue(auth.headers['set-cookie'], 'ory_kratos_continuity');

    const authorize = await got(authorizeUrl, {
      "headers": {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      },
      "method": "GET",
      throwHttpErrors: false,
      followRedirect: false,
    });

    assert.equal(authorize.statusCode, 302, 'Expected to receive a redirect to login');
    assert(authorize.headers.location, 'Expected to receive redirect location for login');
    const loginUrl = new URL(authorize.headers.location);
    const sessionDataKey = loginUrl.searchParams.get('sessionDataKey');
    assert(sessionDataKey, 'Need to extract session data key from login redirect URL');

    const bodyParamsCredentials = new URLSearchParams({
        username,
        password,
        sessionDataKey,
    });
    const commonAuth = await got(`${loginUrl.origin}/commonauth`, {
      "headers": {
        "Referer": loginUrl.toString(),
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "content-type": "application/x-www-form-urlencoded",
      },
      body: bodyParamsCredentials.toString(),
      "method": "POST",
      throwHttpErrors: false,
      followRedirect: false,
    });

    assert.equal(commonAuth.statusCode, 302, 'Expected to receive a redirect to authorize');
    assert(commonAuth.headers.location, 'Expected to receive redirect location for authorize');
    assert(commonAuth.headers['set-cookie'], 'Expected cookies to be set');
    const authorizeUrl2 = new URL(commonAuth.headers.location);
    const commonAuthIdCookie = extractCookieValue(commonAuth.headers['set-cookie'], 'commonAuthId');
    assert(commonAuthIdCookie, 'Need commonAuthId cookie to proceed');

    const authorize2 = await got(authorizeUrl2, {
      "headers": {
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "cookie": `commonAuthId=${commonAuthIdCookie}`,
      },
      "method": "GET",
      throwHttpErrors: false,
      followRedirect: false,
    });

    assert.equal(authorize2.statusCode, 302, 'Expected to receive a redirect to authorize');
    assert(authorize2.headers.location, 'Expected to receive redirect location for authorize');
    const idpCallbackUrl = new URL(authorize2.headers.location);

    const idp = await got(idpCallbackUrl, {
        "headers": {
            "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            cookie: `csrf_token=${csrfToken}; ory_kratos_continuity=${kratosContinuityCookie}`
        },
        "method": "GET",
        throwHttpErrors: false,
        followRedirect: false,
    });

    const continuity = extractCookieValue(idp.headers['set-cookie'], 'ory_kratos_continuity');
    const session = extractCookieValue(idp.headers['set-cookie'], 'ory_kratos_session');
    const csrf = extractCookieValue(idp.headers['set-cookie'], 'csrf_token');
    assert(continuity, 'Need ory_kratos_continuity cookie to proceed');
    assert(session, 'Need ory_kratos_session cookie to proceed');
    assert(csrf, 'Need csrf_token cookie to proceed');

    const whoamiResult = await got(`${basePath}/kratos/sessions/whoami`, {
        "headers": {
            "accept": "application/json, text/plain, */*",
            "cookie": `csrf_token=${csrf}; ory_kratos_continuity=${continuity}; ory_kratos_session=${session}`,
        },
        "method": "GET"
    });

    assert.equal(whoamiResult.statusCode, 200, 'Whoami failed');

    return {
        whoami: JSON.parse(whoamiResult.body),
        tokens: {
            continuity,
            session,
            csrf,
        },
        cookie: `ory_kratos_continuity=${continuity}; ory_kratos_session=${session}`,
    };
}
