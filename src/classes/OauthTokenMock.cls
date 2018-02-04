/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This class is used for testing the Oauth 2.0 authentication callout
------------------------------------------------------------*/
@isTest
public class OauthTokenMock implements HttpCalloutMock {
    protected Integer code;
    protected String body;
    protected Map<String, String> responseHeaders;

    // Returns a bearer token like the Twitter API should
    public OauthTokenMock() {
        this.code = 200;
        this.body = '{"access_token":"authkeygoeshere"}';
        this.responseHeaders = new Map<String, String>();
        this.responseHeaders.put('Content-Type', 'application/json');
    }

    // Response that takes a request in for testing, returns
    public HTTPResponse respond(HTTPRequest req) {
        // Make sure endpoint is same
        System.assertEquals('https://api.twitter.com/oauth2/token', req.getEndpoint());
        // Make sure correct endpoint
        System.assertEquals('POST', req.getMethod());
        // Check for proper body
        System.assertEquals('grant_type=client_credentials', req.getBody());
        // Make sure auth is set
        System.assertNotEquals(null, req.getHeader('Authorization'));

        HttpResponse res = new HttpResponse();
        for (String key : this.responseHeaders.keySet()) {
            res.setHeader(key, this.responseHeaders.get(key));
        }
        res.setBody(this.body);
        res.setStatusCode(this.code);
        return res;
    }

}