//
//  BaseViewController.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {

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
}
