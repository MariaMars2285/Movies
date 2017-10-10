//
//  Movie+TMDB.swift
//  
//
//  Created by Maria  on 10/11/17.
//
//

import Foundation
import CoreData

extension Movie {

    convenience init(title: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Movie", in: context) {
            self.init(entity: ent, insertInto: context)
            self.title = title
        } else {
            fatalError("No Entity")
        }
    }
}
