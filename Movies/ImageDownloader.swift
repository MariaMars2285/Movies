//
//  ImageDownloader.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ImageDownloader {
    
    var stack: CoreDataStack {
        get {
            return CoreDataStack.shared
        }
    }
    
    func downloadImage(forURL url: URL, completion: @escaping (Data?, Error?) -> Void) {
        Alamofire.request(url).responseData { (response) in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            guard let data = response.data else {
                completion(nil, nil)
                return
            }
            completion(data, nil)
            
        }
    }
    
    func downloadThumbnail(forVideo video: Video) {
        if let thumbnailURL = video.thumbnailURL() {
            downloadImage(forURL: thumbnailURL, completion: { (data, error) in
                if let imgData = data {
                    video.thumbnail = imgData
                    self.stack.save()
                }
            })
        }
    }
    
    func downloadPoster(forMovie movie: Movie) {
        if let posterURL = movie.posterURL() {
            downloadImage(forURL: posterURL, completion: { (data, error) in
                if let imgData = data {
                    movie.posterData = imgData
                    self.stack.save()
                }
            })
        }
    }
}
