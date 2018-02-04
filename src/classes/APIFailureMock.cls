/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This class is used for testing fail states on API Calls
------------------------------------------------------------*/
@isTest
public class APIFailureMock implements HttpCalloutMock {
    protected Integer code;
    protected String body;
    protected Map<String, String> responseHeaders;

    // Just sets up a failed call
    public APIFailureMock() {
        this.code = 500;
        this.body = '{"error":"someErrorHere"}';
    }

    // Response that takes a request in for testing, returns an error
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody(this.body);
        res.setStatusCode(this.code);
        return res;
    }
}