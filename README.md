Card (formely known as Memify)
====================
v 1.0
---------------------

### TODO
* Code refactored, add useful comments and remove old code (Ryan)
* Take photo (gifs), video or upload from album (Ryan)
* Send media to all friends
* log in as page admin?
* Fix Async functionality throughout application (refactored code, loading spinners fixed and active) (Ryan)
* Refreshing of cards fixed and optimized (Ben)
* Terms,privacy, agreement is created and added to bottom of login screen
* Add flipping card animation, show image on back
* ~~Add swiping left/right functionality/animation to delete or save card~~ (Ben)
* Card deck/stack animation (showing ability to invite friends to app/send card when you have no cards loaded) (Ben)
* ~~Ability to take pictures with camera~~ (Ben)
* When users upload images, send image to server at ryansickles.com and host reference (Ryan)
* Buy developers account to test app on local device
* Write tests for code functionality (in tests file)
* Save app data to local phone storage when app is killed
* App Logo
* ~~Function to cascade delete from function table to card table~~ (Ben)
*  Send to mutiple recepients (ryan)
*  Using core data to store info and caching images
*  Website for app to get subscribers

###Feature Creep
* Add ability to get random XKCD comic (Ben)
* Ability to search google (internet) for images (Ryan)
* Promo video
* Add ability to upload facebook images (Ben)
* "Forward" Card?
* Optimize search on IMGUR for only images with meme tags (Ryan)

### UX
* Cards designed
* Logo/buttons designed
* Color scheme
* View Controller animations
* Card animations (sending/recieving/viewing)
* Card colors based on source type

### UI
* Cards that display from user w/ pro picture
* Cards have picture sent with personal message
* Card swiping functionality to save or delete card

### Media Types 
* Static Images (Imgur, Facebook, Camera Roll, Google, XKCD, Instagram)
* GIFs (IMGUR, Google, Camera Roll)
* Video (Youtube, VIMEO, Vine)
* Articles from the web and Tweets (Twitter)
* Events (to add to calendar on local phones, google calendar)
* Flashes
* Music (Soundcloud, Spotify, Pandora)

###Card Front
* Sender Name
* Profile Picture
* Message
* Timestamp (When card was sent)
* Color of card w/ icon (depends on source type)

###Card Back
* Full screen of the image
* Webview for online content (articles)

###Card Interaction

* Swipe Left is to trash the card
* Recently deleted table with cells with images
* Swipe Right (functionality based on media type)
* Swipe Up/down for forwarding (brings up friendimagepicker)

### Database
* User Table (socialmedia-user-id, first-name, last-name)
* Card Table (card-id, media reference, media_type, source-type, active-state, time-stamp-created, flipped)
* Link Table (sender-id, receiver-id, card-id)

### Features
* Ability to send Facebook, Camera Roll, IMGUR, Google, Personal Link images

### Audience
* App description and purpose statment (what problem we are solving)
* Published in Apple App Store

### Additional Features for feature branch
* Send tracks to friends using soundcloud cards (SoundCloud API)
* Random XKCD comics sent
