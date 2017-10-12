//
//  ImageDownloader.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    var stack: CoreDataStack {
        get {
            return CoreDataStack.shared
        }
    }
    
    func downloadThumbnail(forVideo video: Video) {
        if let thumbnailURL = video.thumbnailURL() {
            let downloadQueue = DispatchQueue(label: "download", attributes: [])
            
            downloadQueue.async { () -> Void in
                let imgData = try? Data(contentsOf: thumbnailURL)
                DispatchQueue.main.async(execute: { () -> Void in
                    video.thumbnail = imgData
                    self.stack.save()
                })
            }
        }
    }
    
    func downloadPoster(forMovie movie: Movie) {
        if let posterURL = movie.posterURL() {
            let downloadQueue = DispatchQueue(label: "download", attributes: [])
            
            downloadQueue.async { () -> Void in
                let imgData = try? Data(contentsOf: posterURL)
                DispatchQueue.main.async(execute: { () -> Void in
                    movie.posterData = imgData
                    self.stack.save()
                })
            }
        }
    }
}
