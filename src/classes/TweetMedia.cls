/*------------------------------------------------------------
Author:        Mike Northorp
Description:   Simple wrapper class used for the media porition of a tweet to get a list of attached images back
			   either animated gif or photos
Test Class:    TwitterTests 
------------------------------------------------------------*/
public class TweetMedia {
	public List<Media> media {get;set;}

	// Returns a list of just photo URLs depending on type defined in Media
	public List<String> generatePhotoList() {
		List<String> photos = new List<String>();

		// Loop through the list of media, and add any photo URLs to the list that gets returned
		for(Media singleMedia : media) {
			if(singleMedia.type == 'photo' || singleMedia.type == 'animated_gif') {
				photos.add(singleMedia.media_url_https);
			}
		}

		return photos;
	}

	// The inner media element for extended entities that stores media URLs and Types
	public class Media {
		public String media_url_https{get;set;}
		public String type{get;set;}
	}
}