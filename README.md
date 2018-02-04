# Salesforce Twitter Thing

# Overview

![pic](https://imgur.com/zUGp7tw.png)

This small application shows the latest 10 tweets from the Salesforce twitter page. 
It includes images if applicable with tweets. Various information is displayed for each tweet including:
* Screen Name (@name)
* Username
* User Profile Image
* Date of Tweet (MMM DD YYYY)
* Tweet Contents (Including images and Retweet text if retweet)
* Number of Retweets

### Quick Filter
The app has an input field near the top of the page that allows quick filtering on any content in the Tweets displayed. As the user types the Tweets will
narrow down based on the criteria (case sensitive). 

### Auto Refresh
The top 10 tweets are refreshed every minute if a user is veiwing the page.

### Customization
The app can be customized in the code to pull from other Timelines, as well as the number of tweets increased (although rate limiting / general limits may prevent this from going too high).

### Design
The view is styled using lightning design systems to make it look fancy. It displays them in a feed item view. Responsive too.

### Front end choice
Front end was built on Visualforce instead of lightning just due to personal preference, but should be able to be ported to lightning fairly easily. Although the app will currently work in both lightning and classic on the Salesforce platform.

# Setup
1. If not logging directly into existing orginization, install unmanaged package provided [unmanaged package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1N0000028mVX)
2. IMPORTANT Ensure custom settings for Consumer Key and Consumer Secret are set up properly in the orginization (taken from Twitter generated App)
3. App is viewable at yoursalesforcedomain.com/apex/TwitterViewPage or going to the Salesforce Twitter Feed Tab (may be in + tabs)

# Code Structure

### Classes
* Tweet.cls - Used to store all the tweet attributes that we need to display
* TweetMedia.cls - Stores attached media that comes with a tweet, has inner Media class for each attached photo / gif
* TweetUser.cls - Stores the Username and Screen Name, as well as profile image url

* TwitterAPIInterface.cls - Basic interface that could be used to build out different kinds of TwitterAPIRequests
* TwitterAPIRequest.cls - Main request class that authenticates and is able to send a request to the User Timeline Twitter endpoint

* TwitterViewController.cls - Main controller that handles intialization on page load, sends out the request to the Twitter Timeline API and handles errors received (by displaying the error message)

### Tests
* TwitterTests.cls - Main tests for all classes, utilizes mock classes created for HTTP responses
* TwitterTimelineMock.cls - Tests the main Twitter Timeline request
* APIFailureMock.cls - Used for testing failstates on requests (non 200 response)
* OauthTokenMock.cls - Used to test the initial oauth 2.0 POST request

### Page Structure
* TwitterViewPage.page - Styled with LDS in a simple feed layout, has code to filter on Tweets and automatically refresh each minute
* TwitterViewCmp.cmp - Split out the Tweet and its styles into its own component for better modularity and potential reuse.

# Testing
* Apex Unit Tests for coverage of Server Side code
* Mock HTTP Responses to test various requests and handling of responses, 
* Front end Javascript ran through jshint
* Minimal Front End testing due to low amount of javascript and unfamiliarity Jasmine. Also not much JS to test on Front End, very minimal.

## Resources
* [Salesforce Official Documentation](https://developer.salesforce.com/docs/) - General Apex / SF Docs
* [Lightning Design System Documentation](https://www.lightningdesignsystem.com/)
* [JSON Formatter](https://jsonformatter.curiousconcept.com/) - Easier Response Views
* [Postman](https://www.getpostman.com/) - Testing HTTP Requests / Responses
* [Twitter Developer Documentation](https://developer.twitter.com)
* Salesforce Stack Exchange / Stack Overflow 