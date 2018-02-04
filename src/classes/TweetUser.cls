public class TweetUser {
	public String screen_name {
		get { // Get screenName of user with @
			if(name != null) {
	    		return '@' + screen_name;
	    	} return null; 
    	}
    	set;
	}
    public String name; // Username
    public String profile_image_url_https; // Profile image url
}