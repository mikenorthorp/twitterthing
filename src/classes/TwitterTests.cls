/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This class runs various tests on the Twitter Challenge program. 
------------------------------------------------------------*/
@isTest
private class TwitterTests {
	// Test callout functionality with some mock HTTP responses
	@isTest static void twitterCalloutTests() {
		// Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new OauthTokenMock());
        
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        TwitterAPIRequest apiRequest = new TwitterAPIRequest();

        // Set mock callout class for timeline api callout
        Test.setMock(HttpCalloutMock.class, new TwitterTimelineMock());
        apiRequest.sendRequest('https://api.twitter.com/1.1/statuses/user_timeline.json?', null, 'GET', null);
        System.assertEquals(200, apiRequest.getResponseCode());
        System.assertNotEquals(null, apiRequest.getResponseBody());
        System.assertNotEquals(null, apiRequest.getFullResponse());

        // Set mock callout class for failure 
        Test.setMock(HttpCalloutMock.class, new APIFailureMock());
        apiRequest.sendRequest('https://api.twitter.com/1.1/statuses/user_timeline.json?', null, 'GET', null);
        System.assertNotEquals(200, apiRequest.getResponseCode());

        // Make sure the access token is null now
        System.assertEquals(null, apiRequest.getBearerAccessToken());
	}

	// Test controller initialization with mock http responses
	@isTest static void testTweets() {
		Test.setMock(HttpCalloutMock.class, new TwitterTimelineMock());

		TwitterViewController controller = new TwitterViewController();

		// Check to make sure tweet list is populated properly
		System.assertNotEquals(null, controller.tweetList);
		// No errors being displayed
		System.assertEquals('none', controller.errorStyle);

		// Test tweets
		Tweet tweet = new Tweet();

        TweetUser tweetUser = new TweetUser();
        tweetUser.name = 'testing';
        tweetUser.screen_name = 'testing';
        tweetUser.profile_image_url_https ='www.testimage.com/test.jpg';
        tweet.user = tweetUser;

        // Set up media objects
        TweetMedia tweetMedia = new TweetMedia();
        List<TweetMedia.Media> mediaList = new List<TweetMedia.Media>();
        TweetMedia.Media myMedia = new TweetMedia.Media();
        myMedia.media_url_https = 'www.testimage.com/test.jpg';
        myMedia.type = 'photo';
        tweetMedia.media = mediaList;
        tweet.extended_entities = tweetMedia;

        // Remaining tweet properties
        tweet.created_at = 'THU FEB 06 2018';
    	tweet.full_text = 'This is a test';
        tweet.retweet_count = 10;

        // Test some tweet methods
        System.assertEquals(false, Tweet.isRetweet());
        tweet.retweeted_status = tweet;
        System.assertEquals(true, Tweet.isRetweet());
	}
		
}