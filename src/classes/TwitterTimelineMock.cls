/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This class is used for testing the Twitter Timeline callout
------------------------------------------------------------*/
@isTest
public class TwitterTimelineMock implements HttpCalloutMock {
    protected Integer code;
    protected String body;
    protected Map<String, String> responseHeaders;

    // Returns a bearer token like the Twitter API should
    public TwitterTimelineMock() {
        this.code = 200;
        this.body = '[{"userName":null,"user":{"screen_name":"@salesforce","profile_image_url_https":"https://pbs.twimg.com/profile_images/716283264881700865/voT_NePC_normal.jpg","name":"Salesforce"},"tweetDate":null,"tweetContent":null,"screenName":null,"retweeted_status":null,"retweetCount":null,"retweet_count":4,"profileImageUrl":null,"photoList":null,"full_text":"&#128075; Did you miss Salesforce CEO session discussing the impacts of tech on global food security? Watch it all here: https://t.co/e0PKTeQhFM https://t.co/ATyMbnYJfl","extended_entities":{"media":[{"type":"photo","media_url_https":"https://pbs.twimg.com/media/DVJxt3eXkAA8OJU.jpg"}]},"created_at":"Sun Feb 04 01:00:13 +0000 2018"}]';
        this.responseHeaders = new Map<String, String>();
        this.responseHeaders.put('Content-Type', 'application/json');
    }

    // Response that takes a request in for testing, returns for twitter timeline
    public HTTPResponse respond(HTTPRequest req) {
        // Make sure correct endpoint
        System.assertEquals('GET', req.getMethod());
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