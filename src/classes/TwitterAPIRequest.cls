/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This class is used for authenticating and sending a request to the Twitter API. Returns JSON and response information
Test Class:    TwitterTests
------------------------------------------------------------*/
public class TwitterAPIRequest implements TwitterAPIInterface {
    // Taken from twitter API and stored in custom setting
    private String consumerKey;
    private String consumerSecret;

    // This is the resourceUrl + the param's passed in
    private String fullRequestEndpoint; 
    
    // Used for the response and request to the Twitter API
    private HTTPResponse response;
    private HttpRequest req; 

    public TwitterAPIRequest() {
        // Set up authorization header and request
        req = new HttpRequest();

        // Set authorization header value using the bearerToken generated with oAuth 2.0
        String accessToken = getBearerAccessToken();

        if(accessToken != null) {
            String authorizationHeader = 'Bearer ' + accessToken;
            req.setHeader('Authorization', authorizationHeader);
        }
    }

    // Sends the request passed in and returns the body of the request (this method doesn't use payload, optional for POST)
    public String sendRequest(String resourceUrl, Map<String,String> params, String requestMethod, String payload) {
        fullRequestEndpoint = resourceUrl;
        // Add all the paramaters onto the endpoint
        if(params != null) {
            for(String paramKey : params.keySet()) {
                fullRequestEndpoint += paramKey + '=' + params.get(paramKey) + '&';
            }
        }

        // Trim the & off of the URL if param's were added on
        if(params != null) {
            fullRequestEndpoint = fullRequestEndpoint.substring(0, fullRequestEndpoint.length()-1);
        }

        // Set the endpoint with the fully build URL
        req.setEndpoint(fullRequestEndpoint);

        // Set the request method (GET in this case)
        req.setMethod(requestMethod);

        // Send the request and return the response
        Http http = new Http();
        response = http.send(req);

        return response.getBody();
    }

    // Returns the most recent response as a string for parsing
    public String getResponseBody() {
        if(response != null) {
            return response.getBody();
        } return null;
    }

    // This returns the full response if needed
    public HTTPResponse getFullResponse() {
        return response;
    }

    // Returns the response Status code for error checking
    public Integer getResponseCode() {
        if(response != null) {
            return response.getStatusCode();
        } return null;
    }

    /* This method allows Oauth 2.0 authentication to get an access token back for future requests
    /* Returns an access token
    /* Based on source https://salesforce.stackexchange.com/questions/29359/unable-to-authenticate-to-twitter 
    /* stack overflow post helped guide me in the right direction after trying more difficult oauth 1.0 calculations
    /* as well as official docs https://developer.twitter.com/en/docs/basics/authentication/api-reference/token */
    public String getBearerAccessToken() {
        twitterOauth__c myAuth = twitterOauth__c.getInstance();

        if(Test.isRunningTest()) {
            consumerKey = 'testKey';
            consumerSecret = 'testSecret';
        } else {
            if(myAuth != null && myAuth.ConsumerKey__c != null && myAuth.ConsumerSecret__c != null) {
                consumerKey = myAuth.ConsumerKey__c;
                consumerSecret = myAuth.ConsumerSecret__c;
            } else {
                consumerKey = '';
                consumerSecret = '';
                System.debug('You must set the consumer key and consumer secret in custom settings for Twitter Oauth');
            }
        }

        String consumerKeyEncoded = EncodingUtil.urlEncode(consumerKey, 'UTF-8');
        String consumerSecretEncoded = EncodingUtil.urlEncode(consumerSecret, 'UTF-8');

        // Create Final Key String
        String keyString = consumerKey + ':' + consumerSecret;

        // Convert to Blob
        Blob headerValue = Blob.valueOf(keyString);

        // Set up request agaisnt oauth2 token endpoint, and grant client_credentials
        HttpRequest tokenRequest = new HttpRequest();
        tokenRequest.setEndpoint('https://api.twitter.com/oauth2/token');
        tokenRequest.setMethod('POST');
        tokenRequest.setBody('grant_type=client_credentials');

        // Set the authorization header
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        tokenRequest.setHeader('Authorization', authorizationHeader);

        // Make request to get access token
        Http tokenHttp = new Http();
        HTTPResponse tokenResponse = tokenHttp.send(tokenRequest);
        String accessToken;

        // Get the bearer token from the JSON
        try {
            JSONParser parser = JSON.createParser(tokenResponse.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token'){
                    parser.nextToken();
                    accessToken = parser.getText();
                    break;
                }
            }
        } catch(System.CalloutException e) {
            System.debug(e);
            accessToken = null;
        }

        // Return the access token string
        return accessToken;
    }
}