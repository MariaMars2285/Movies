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
                // TODO: Delete all movies from Core Data.
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

}
