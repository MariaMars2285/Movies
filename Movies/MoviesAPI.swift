//
//  MoviesAPI.swift
//  Movies
//
//  Created by Maria  on 10/11/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class MoviesAPI {

    func fetchMovies(page: Int, completion:@escaping ([JSON]?, Error?) -> Void) {
        
        let params: [String: Any] = [
            Constants.TMDBParameterKeys.APIKey: Constants.TMDBParameterValues.APIKey,
            Constants.TMDBParameterKeys.Language: Constants.TMDBParameterValues.Language,
            Constants.TMDBParameterKeys.Page: page
        ]
        
        let url = TMDBURLFromParameters(path: "/3/movie/upcoming", parameters: params as [String: AnyObject])
        print(url.absoluteString)
        
        Alamofire.request(url.absoluteString).response { response in
            // TODO: Handle Errors
            if let data = response.data {
                let json = JSON(data: data)
                if let moviesJSON = json[Constants.TMDBResponseKeys.Results].array {
                    completion(moviesJSON, nil)
                }
            }
        }
    }
    
    func fetchMovieDetails(movie: Movie, completion: @escaping (JSON?, Error?) -> Void) {
        let params: [String: Any] = [
            Constants.TMDBParameterKeys.APIKey: Constants.TMDBParameterValues.APIKey,
            Constants.TMDBParameterKeys.Language: Constants.TMDBParameterValues.Language,
        ]
        
        let url = TMDBURLFromParameters(path: "/3/movie/\(movie.id)", parameters: params as [String: AnyObject])
        print(url.absoluteString)
        
        Alamofire.request(url.absoluteString).response { response in
            // TODO: Handle Errors
            if let data = response.data {
                let json = JSON(data: data)
                completion(json, nil)
            }
        }
    }
    
    func fetchVideos(movie: Movie, completion: @escaping ([JSON]?, Error?) -> Void) {
        let params: [String: Any] = [
            Constants.TMDBParameterKeys.APIKey: Constants.TMDBParameterValues.APIKey,
            Constants.TMDBParameterKeys.Language: Constants.TMDBParameterValues.Language,
            ]
        
        let url = TMDBURLFromParameters(path: "/3/movie/\(movie.id)/videos", parameters: params as [String: AnyObject])
        print(url.absoluteString)
        
        Alamofire.request(url.absoluteString).response { response in
            // TODO: Handle Errors
            if let data = response.data {
                let json = JSON(data: data)
                if let videosJSON = json[Constants.TMDBResponseKeys.Results].array {
                    completion(videosJSON, nil)
                }
            }
        }
    }
        
    
    private func TMDBURLFromParameters(path: String, parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.TMDB.APIScheme
        components.host = Constants.TMDB.APIHost
        components.path = path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}

extension MoviesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths  = [IndexPath]()
        updatedIndexPaths  = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            insertedIndexPaths.append(newIndexPath!)
        case .update:
            updatedIndexPaths.append(indexPath!)
        case .delete:
            deletedIndexPaths.append(indexPath!)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItems(at: [indexPath])
            }
            for indexPath in self.updatedIndexPaths {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
    
}
