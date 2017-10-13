//
//  MoviesManager.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import CoreData

class MoviesManager {
    
    var context: NSManagedObjectContext {
        get {
            return CoreDataStack.shared.context
        }
    }
    
    var stack: CoreDataStack {
        get {
            return CoreDataStack.shared
        }
    }
    
    let moviesAPI = MoviesAPI()
    
    // Fetches movies from Movies API and creates Core data objects from JSON.
    func fetchMovies(page: Int, completion:@escaping ([Movie]?, Error?) -> Void) {
        moviesAPI.fetchMovies(page: page) { (jsons, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let moviesJSON = jsons else {
                completion(nil, error)
                return
            }
            
            if page == 1 {
                let fetchRequest = NSFetchRequest<Movie>(entityName: Constants.EntityNames.Movie)
                do {
                    let results = try self.context.fetch(fetchRequest)
                    for movie in results {
                        self.context.delete(movie)
                    }
                } catch {
                    
                }
            }
            
            var movies: [Movie] = []
            for movieJSON in moviesJSON {
                if movieJSON[Constants.TMDBResponseKeys.ID].int != nil &&
                    movieJSON[Constants.TMDBResponseKeys.Title].string != nil {
                    let movie = Movie(json: movieJSON, context: self.context)
                    movies.append(movie)
                }
            }
            self.stack.save()
            completion(movies, nil)
        }
    }
    
    // Fetches movie details from Movies API and creates/updates movie details in Core Data.
    func fetchMovieDetails(movie: Movie, completion: @escaping (MovieDetail?, Error?) -> Void) {
        moviesAPI.fetchMovieDetails(movie: movie) { (json, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let detailsJSON = json else {
                completion(nil, error)
                return
            }
            
            if let detail = movie.detail {
                //Update Movie Detail
                detail.updateMovieDetails(json: detailsJSON)
            } else {
                //Create Movie Detail
                let detail = MovieDetail(json: detailsJSON, movie: movie, context: self.context)
                completion(detail, nil)
            }
        }
    }
    
    // Fetches videos from Movies API and creates Core data objects from JSON.
    func fetchVideos(movie: Movie, completion: @escaping ([Video]?, Error?) -> Void) {
        moviesAPI.fetchVideos(movie: movie) { (jsons, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let videosJSON = jsons else {
                completion(nil, error)
                return
            }
            if movie.videos != nil && movie.videos!.count > 0 {
                for video in movie.videos! {
                    self.context.delete(video as! Video)
                }
            }
            var videos: [Video] = []
            for json in videosJSON {
                let video = Video(json: json, movie: movie, context: self.context)
                videos.append(video)
            }
            self.stack.save()
            completion(videos, nil)
        }
    }

}
