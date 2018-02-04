/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This is used as a general authentication / request interface to 
               build out Twitter API requests for Tweets
------------------------------------------------------------*/
public interface TwitterAPIInterface {
    // Sends a request and takes in resourceUrl, params, requestMethod and payload(optional)
    String sendRequest(String resourceUrl, Map<String,String> params, String requestMethod, String payload); 

    // Should be used to return the most recent response string / Status
    String getResponseBody(); 
    HTTPResponse getFullResponse();
    Integer getResponseCode();

    // Method to get the access token
    String getBearerAccessToken();
}