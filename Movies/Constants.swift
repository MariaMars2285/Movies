//
//  Constants.swift
//  Movies
//
//  Created by Maria  on 10/11/17.
//  Copyright © 2017 Maria . All rights reserved.
//


import Foundation

// MARK: - Constants

// Constants used in the project.
struct Constants {
    
    // MARK: TMDB
    struct TMDB {
        static let APIScheme = "https"
        static let APIHost = "api.themoviedb.org"
        static let BaseAPIPath = "/3"
        static let LargeImageURL = "https://image.tmdb.org/t/p/w1000"
        static let SmallImageURL = "https://image.tmdb.org/t/p/w300"
    }
    
    // MARK: TMDB Parameter Keys
    struct TMDBParameterKeys {
        static let APIKey = "api_key"
        static let Page = "page"
        static let Language = "language"
    }
    
    // MARK: TMDB Parameter Values
    struct TMDBParameterValues {
        static let APIKey = "YOUR_API_KEY_HERE"
        static let Language = "en-US"
    }
    
    // MARK: TMDB Response Keys
    struct TMDBResponseKeys {
        static let Results = "results"
        static let ID = "id"
        static let Title = "title"
        static let Poster = "poster_path"
        static let ReleaseDate = "release_date"
        static let Language = "original_language"
        static let Backdrop = "backdrop_path"
        static let HasVideo = "video"
        static let Homepage = "homepage"
        static let IMDBId = "imdb_id"
        static let Overview = "overview"
        static let Key = "key"
        static let Name = "name"
        static let Site = "site"
        static let VideoType = "type"
        static let StatusMessage = "status_message"
    }
    
    // MARK: TMDB Response Values
    struct TMDBResponseValues {
    }
    
    // MARK: Entity Names
    struct EntityNames {
        static let Movie = "Movie"
        static let Video = "Video"
    }
    
    // MARK: Cell Identifiers
    struct CellIdentifiers {
        static let MovieGridCell = "MovieGridCell"
        static let VideoGridCell = "VideoGridCell"
    }
    
}

