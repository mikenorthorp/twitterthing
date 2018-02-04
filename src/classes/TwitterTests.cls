/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This class runs various tests on the Twitter Challenge program. Including HTTP callout testing, and Tweet / associated 
			   class testing. 

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

	// Test the main apex controller
	@isTest static void testController() {
		Test.setMock(HttpCalloutMock.class, new TwitterTimelineMock());

		TwitterViewController controller = new TwitterViewController();

		// Check to make sure tweet list is populated properly
		System.assertNotEquals(null, controller.tweetList);
		// No errors being displayed
		System.assertEquals('none', controller.errorStyle);
	}

	// Test the Tweet and associated classes
	@isTest static void testTweets() {
		// Build out our test Tweet
		Tweet testTweet = new Tweet();

	    // Main tweet properties
        testTweet.created_at = 'THU FEB 06 2018';
    	testTweet.full_text = 'This is a test';
        testTweet.retweet_count = 10;

        // Check to see full retweet content
        System.assertEquals('This is a test', testTweet.tweetContent);

        TweetUser tweetUser = new TweetUser();
        tweetUser.name = 'testing';
        tweetUser.screen_name = 'testing';
        tweetUser.profile_image_url_https ='www.testimage.com/test.jpg';
        testTweet.user = tweetUser;

        // Set up media objects
        TweetMedia tweetMedia = new TweetMedia();
        List<TweetMedia.Media> mediaList = new List<TweetMedia.Media>();
        TweetMedia.Media myMedia = new TweetMedia.Media();
        myMedia.media_url_https = 'www.testimage.com/test.jpg';
        myMedia.type = 'photo';
        mediaList.add(myMedia);

        // Set the media list now and extended entities
        tweetMedia.media = mediaList;
        testTweet.extended_entities = tweetMedia;

        // Test tweet methods
        System.assertEquals(false, testTweet.isRetweet());
        testTweet.retweeted_status = testTweet;
        System.assertEquals(true, testTweet.isRetweet());

        // Check to see full retweet content
       	System.assertEquals('RT @testing: This is a test', testTweet.tweetContent);

        // Tweet date should always be same length and trim off the Day
        System.assertEquals(12, testTweet.tweetDate.length());

        // Make sure retweet count is 10
        System.assertEquals('10', testTweet.retweetCount);

        // User tests
        System.assertEquals('@testing', testTweet.screenName);
        System.assertEquals('testing', testTweet.userName);
        System.assertEquals('www.testimage.com/test.jpg', testTweet.profileImageUrl);

        // Media tests
        // Make sure photo list has an element in it
        System.assertEquals(1, testTweet.photoList.size());
	}
		
}