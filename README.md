# Upcoming Movies

Upcoming Movies App displays 20 upcoming movies from TMDB API. It allows user to view the upcoming movie details and play the videos associated with the movies.  

# Installation Instructions
- Clone the source code from https://github.com/MariaMars2285/Movies 
- Open Movies.xcworkspace file in Xcode. Make sure you do not open the xcproject.
- Get your API key from the www.themoviedb.org link and replace the "APIKey" Parameter value with your API key in Constants.swift file .
- Now compile and run.

# User Interface
### Movies Screen
- On load the app will display the upcoming 20 movies from TMDB API.
- On click of settings icon on top right will take you to a page where the user can select Grid Size
- Clicking on the movie image will take user to the Movie Detail Page.

### Settings Screen
- Sets the user preference for Grid Size based on User choice.
- The Selected Grid Size will be used in the Movies Screen. 

### Movie Detail Screen
- On load, the poster, backdrop of the Movie selected is shown and Synopsis of the Movie is displayed below that.
- Below synopsis are three links - Homepage, Video and IMDB. 
- On click of Homepage will take user to the website associated to the movie. If there is no site associated then Homepage button will be disabled.
- On click of Video will take user to the Videos page where the videos associated to the movie are displayed.
- On click of IMDB will take user to the IMDB page of the movie selected.
- On top Nav, there is a video button available. On click of it will again take the user to videos page where videos associated to the movie are displayed.

### Videos Page
- Videos page on load displays the videos available for the movie selected.
- On click of the video will take user to the youtube page where user can play the video.

# Code Attribution

- Alamofire open source library from https://github.com/Alamofire/Alamofire
- SwiftyJSON for JSON Parsing
- CoreDataStack from https://github.com/udacity/ios-nd-persistence/blob/master/CoolNotes/13-CoreDataAndConcurrency/CoolNotes/CoreDataStack.swift
- Adding borders to Collection View Cell from https://stackoverflow.com/questions/13505379/adding-rounded-corner-and-drop-shadow-to-uicollectionviewcell.
- Pull to refresh from https://stackoverflow.com/questions/35362440/pull-to-refresh-in-uicollectionview-in-viewcontroller
