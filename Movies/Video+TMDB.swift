//
//  Video+TMDB.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension Video {
    
    convenience init(json: JSON, movie: Movie, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Video", in: context) {
            self.init(entity: ent, insertInto: context)
            self.movie = movie
            self.key = json[Constants.TMDBResponseKeys.Key].stringValue
            self.id = json[Constants.TMDBResponseKeys.ID].stringValue
            self.name = json[Constants.TMDBResponseKeys.Name].string
            self.site = json[Constants.TMDBResponseKeys.Site].string
            self.type = json[Constants.TMDBResponseKeys.VideoType].string
        } else {
            fatalError("No Entity")
        }
    }
    
    func thumbnailURL() -> URL? {
        if let key = self.key {
            return URL(string: "https://img.youtube.com/vi/\(key)/0.jpg")
        }
        return nil
    }
    
    func youtubeURL() -> URL? {
        if let key = self.key {
            return URL(string: "https://www.youtube.com/watch?v=\(key)")
        }
        return nil
    }
}
