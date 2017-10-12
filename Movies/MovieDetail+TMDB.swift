//
//  MovieDetail+TMDB.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension MovieDetail {
    
    convenience init(json: JSON, movie: Movie, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "MovieDetail", in: context) {
            self.init(entity: ent, insertInto: context)
            self.movie = movie
            updateMovieDetails(json: json)
        } else {
            fatalError("No Entity")
        }
    }
    
    func updateMovieDetails(json: JSON) {
        self.title = json[Constants.TMDBResponseKeys.Title].stringValue
        self.poster = json[Constants.TMDBResponseKeys.Poster].string
        self.backdrop = json[Constants.TMDBResponseKeys.Backdrop].string
        self.hasVideo = json[Constants.TMDBResponseKeys.HasVideo].boolValue
        self.homepage = json[Constants.TMDBResponseKeys.Homepage].string
        self.imdbID = json[Constants.TMDBResponseKeys.IMDBId].string
        self.overview = json[Constants.TMDBResponseKeys.Overview].string
    }
    
    func homepageURL() -> URL? {
        if let homepage = self.homepage {
            return URL(string: homepage)
        }
        return nil
    }
    
    func imdbURL() -> URL? {
        if let imdbId = self.imdbID {
            return URL(string: "http://www.imdb.com/title/\(imdbId)")
        }
        return nil
    }
    
    func backdropURL() -> URL? {
        if let backdrop = self.backdrop {
            return URL(string: Constants.TMDB.LargeImageURL + backdrop)
        }
        return nil
    }
    
}
