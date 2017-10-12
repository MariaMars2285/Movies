//
//  Movie+TMDB.swift
//  
//
//  Created by Maria  on 10/11/17.
//
//

import Foundation
import CoreData
import SwiftyJSON

extension Movie {
    
    convenience init(json: JSON, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Movie", in: context) {
            self.init(entity: ent, insertInto: context)
            self.title = json[Constants.TMDBResponseKeys.Title].stringValue
            self.id = json[Constants.TMDBResponseKeys.ID].int64Value
            self.language = json[Constants.TMDBResponseKeys.Language].string
            self.poster = json[Constants.TMDBResponseKeys.Poster].string
            //self.releaseDate = json[Constants.TMDBResponseKeys.ReleaseDate].
        } else {
            fatalError("No Entity")
        }
    }
    
    func posterURL() -> URL? {
        if let path = self.poster {
            return URL(string: Constants.TMDB.SmallImageURL + path)
        }
        return nil
    }
}
