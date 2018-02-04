/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This is the main controller for the TwitterViewPage
Inputs:        
Test Class:   
------------------------------------------------------------*/
public class TwitterViewController{
	// List of tweets which should be returned from API
    public List<Tweet> tweetList {get; private set;}
    public String errorStyle {get;set;}
    public String errorMessage {get;set;}

    // Create needed vars for request, api parameters, twitter resourceUrl and requestMethod, response
    private TwitterAPIRequest request;
    private Map<String, String> apiParams;
    private String resourceUrl;
    private String requestMethod;
    private String apiResponse;

    // Api parameters passed into the resource url
    private String screen_name = 'salesforce';
    private Integer tweetCount = 10;
    private String tweet_mode = 'extended';

    public TwitterViewController() {
    	// Init the API Request and paramaters
    	request = new TwitterAPIRequest();
    	apiParams = new Map<String, String>();
    	requestMethod = 'GET';
    	resourceUrl = 'https://api.twitter.com/1.1/statuses/user_timeline.json?';

    	// Add the proper parameters to query Salesforce
    	apiParams.put('count', String.valueOf(tweetCount));
    	apiParams.put('screen_name', screen_name);
    	apiParams.put('tweet_mode', tweet_mode);

    	// Send the request out with the proper parameters, this querys the Twitter user Timeline to get the last 10 tweets
    	apiResponse = request.sendRequest(resourceUrl, apiParams, requestMethod, null);
    	System.debug(apiResponse);

    	// Make sure response is sucessful and set up the list of tweets with the parser
    	if(apiResponse != null && request.getResponseCode() == 200) {
    		// Hide the error since there is none
    		errorStyle = 'none';

    		// Init the list of tweets
	    	tweetList = new List<Tweet>();

	    	// Set the list of tweets by parsing the response from the Timeline request
	    	tweetList = parseJson(apiResponse);
	    	System.debug(tweetList);
    	} else {
    		// Set error if there was an issue with the response code
    		// Show the error style so it shows the element on the page
    		errorStyle = 'block';

    		// Set the message based on response
    		if(apiResponse != null) {
    			errorMessage = request.getResponseBody();
    		} else {
    			errorMessage = 'The request returned null';
    		}
    	}
    }

    // This method dseralizes the json for this request and returns back as a List of tweets. The tweet object
    // is set up to support this
    public static List<Tweet> parseJson(String json) {
        return (List<Tweet>)System.JSON.deserialize(json, List<Tweet>.class);
    }
}