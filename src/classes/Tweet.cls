/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This object represents a Tweet with all its attributes, and is built for JSON deserialization
               As well as methods to properly return the formatted attributes after set with JSON
Test Class:    TwitterTests
------------------------------------------------------------*/
public class Tweet {
    // These are the values the JSON Response dseralizes too
    public String created_at {get;set;}
    public String full_text {get;set;}
    public Integer retweet_count {get;set;}
    public TweetUser user {get;set;} // The user object, contains tweet username, screen name, and img url for profile
    public TweetMedia extended_entities {get;set;} // This object gets attached photos from the tweet
    public Tweet retweeted_status {get;set;} // This will be null unless the tweet is a retweet

    // Attributes of a tweet that we need to display
    // Values used for display with some having custom returns to properly show content, retweeted tweets, etc


    // Get the @name of the Tweet poster
    public String screenName {
        get {
            if(user != null) {
                return user.screen_name;
            } return null;
        }
        private set;
    }

    // Get the actual username of the tweet
    public String userName {
        get {
            if(user != null) {
                return user.name;
            } return null;
        }
        private set;
    }

    // Returns the profile image for the user that tweeted this (not the retweet user)
    public String profileImageUrl {
        get {
            if(user != null) {
                return user.profile_image_url_https;
            } return null;
        }
        private set;
    }

    // Returns the tweet content excluding images (either retweeted tweet, or main tweet)
    public String tweetContent {
        get {
            // If this is a retweet we need to grab the retweeted_status contents, else the main full_text
            if(this.isRetweet()) {
                return 'RT ' + retweeted_status.user.screen_name + ': ' + retweeted_status.full_text;
            } else {
                return full_text;
            } return null;
        }
        private set;
    }

    // Returns the tweet date, or date of the retweet (not the retweets date)
    public String tweetDate {
        get {
            if(created_at != null) {
                // Parse out the Month, Day and Year
                tweetDate = created_at.substring(3,11) + created_at.substring(created_at.length()-4,created_at.length());
                return tweetDate;
            } return null;
        }
        private set;
    }

    // Returns the string representation of the retweetCount, returns 0 if empty
    public String retweetCount {
        get {
            if(retweet_count != null) {
                return String.valueOf(retweet_count);
            } return '0';
        }
        private set;
    }

    // Returns a list of attached photos for this Tweet
    public List<String> photoList {
        get {
             // Call the TweetMedia function to get a list of all photos as Strings
            if(extended_entities != null) {
                return extended_entities.generatePhotoList();
            } return null;
        }
        private set;
    }
    
    // Returns true if this tweet contains a retweeted_status
    public boolean isRetweet() {
        return (retweeted_status != null);
    }
}