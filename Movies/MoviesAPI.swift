//
//  MoviesAPI.swift
//  Movies
//
//  Created by Maria  on 10/11/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import CoreData

class MoviesAPI {
  
    var context: NSManagedObjectContext {
        get {
            return CoreDataStack.shared.context
        }
    }
    
    func fetchMovies(completion:([Movie]?, Error?) -> Void) {
        let movies = [
            Movie(title: "Vivegam", context: context),
            Movie(title: "Vedalam", context: context),
            Movie(title: "Veeram", context: context),
            Movie(title: "Billa", context: context),
            Movie(title: "Mankatha", context: context),
            Movie(title: "Vaali", context: context),
            Movie(title: "Villain", context: context),
            Movie(title: "Amarkalam", context: context),
            Movie(title: "Dheena", context: context),
            Movie(title: "Varalaru", context: context),
        ]
        completion(movies, nil)
    }
}
