/*------------------------------------------------------------
Author:        Mike Northorp
Description:   Simple wrapper for the tweet user to store their profile image, screen name and user name
Test Class:    TwitterTests
------------------------------------------------------------*/
public class TweetUser {
	public String screen_name {
		get { // Get screenName of user with @
			if(name != null) {
	    		return '@' + screen_name;
	    	} return null; 
    	}
    	set;
	}
    public String name {get;set;} // Username
    public String profile_image_url_https {get;set;} // Profile image url
}