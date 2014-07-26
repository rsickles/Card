Card (formely known as Memify)
====================
v 1.0
---------------------

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
