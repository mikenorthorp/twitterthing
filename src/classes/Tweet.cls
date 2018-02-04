/*------------------------------------------------------------
Author:        Mike Northorp
Description:   This object represents a Tweet with all its attributes, and is built for JSON deserialization
Inputs:        userName, screenName, profileImageUrl, tweetContent, retweets, tweetDate
Test Class:   
------------------------------------------------------------*/
public class Tweet {
    // These are the values the JSON Response dseralizes too
    public String created_at;
    public String full_text;
    public Integer retweet_count;
    public TweetUser user; // The user object, contains tweet username, screen name, and img url for profile
    public TweetMedia extended_entities; // This object gets attached photos from the tweet
    public Tweet retweeted_status; // This will be null unless the tweet is a retweet

    // Attributes of a tweet that we need to display
    // Values used for display with some having custom returns to properly show content, retweeted tweets, etc
    private String screenName;
    private String userName;
    private String profileImageUrl;
    private String tweetContent;
    private String tweetDate;
    private String retweetCount;
    private List<String> photoList;
    

    // Returns true if this tweet contains a retweeted_status
    public boolean isRetweet() {
        return (retweeted_status != null);
    }

    // Returns the tweet content excluding images (either retweeted tweet, or main tweet)
    public String gettweetContent() {
        // If this is a retweet we need to grab the retweeted_status contents, else the main full_text
        if(this.isRetweet()) {
            return 'RT ' + retweeted_status.user.screen_name + ': ' + retweeted_status.full_text;
        } else {
            return full_text;
        } return null;
    }

    // Returns a list of attached photos for this Tweet
    public List<String> getphotoList() {
         // Call the TweetMedia function to get a list of all photos as Strings
        if(extended_entities != null) {
            return extended_entities.generatePhotoList();
        } return null;
    }

    // Returns the tweet date, or date of the retweet (not the retweets date)
    public String gettweetDate() {
        if(created_at != null) {
            // Parse out the Month, Day and Year
            String tweetDate = created_at.substring(3,11) + created_at.substring(created_at.length()-4,created_at.length());
            return tweetDate;
        } return null;
    }

    // Returns the profile image for the user that tweeted this (not the retweet user)
    public String getprofileImageUrl() {
        if(user != null) {
            return user.profile_image_url_https;
        } return null;
    }

    // Returns the string representation of the retweetCount, returns 0 if empty
    public String getretweetCount() {
        if(retweet_count != null) {
            return String.valueOf(retweet_count);
        } return '0';
    }

    public String getscreenName() {
        if(user != null) {
            return user.screen_name;
        } return null;
    }

    public String getuserName() {
        if(user != null) {
            return user.name;
        } return null;
    }
}