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

// Generic Movies API Error for the Project.
enum MoviesAPIError: Error {
    case noData
    case network
    case tmdb(String)
    
    var title: String {
        get {
            switch(self) {
            case .noData:
                return "Server Error"
            case .network:
                return "Network Error"
            case .tmdb(_):
                return "TMDB Error"
            }
        }
    }
    
    var message: String {
        get {
            switch(self) {
            case .noData:
                return "Server Failed. Please try again later!"
            case .network:
                return "Network Error. Please try again later!"
            case .tmdb(let x):
                return x
            }
        }
    }
}

class MoviesAPI {

    // Fetches movies and calls the completion handlers with movies jsons.
    func fetchMovies(page: Int, completion:@escaping ([JSON]?, Error?) -> Void) {
        
        let params: [String: Any] = [
            Constants.TMDBParameterKeys.APIKey: Constants.TMDBParameterValues.APIKey,
            Constants.TMDBParameterKeys.Language: Constants.TMDBParameterValues.Language,
            Constants.TMDBParameterKeys.Page: page
        ]
        
        let url = TMDBURLFromParameters(path: "/3/movie/upcoming", parameters: params as [String: AnyObject])
        
        Alamofire.request(url.absoluteString).response { response in
            guard response.error == nil else {
                completion(nil, MoviesAPIError.network)
                return
            }
            if let data = response.data {
                let json = JSON(data: data)
                if let statusMessage = json[Constants.TMDBResponseKeys.StatusMessage].string {
                    completion(nil, MoviesAPIError.tmdb(statusMessage))
                    return
                }
                if let moviesJSON = json[Constants.TMDBResponseKeys.Results].array {
                    completion(moviesJSON, nil)
                }
            } else {
                completion(nil, MoviesAPIError.noData)
            }
        }
    }
    
    // Fetches movie details for selected movie and calls the completion handlers with detail jsons.
    func fetchMovieDetails(movie: Movie, completion: @escaping (JSON?, Error?) -> Void) {
        let params: [String: Any] = [
            Constants.TMDBParameterKeys.APIKey: Constants.TMDBParameterValues.APIKey,
            Constants.TMDBParameterKeys.Language: Constants.TMDBParameterValues.Language,
        ]
        
        let url = TMDBURLFromParameters(path: "/3/movie/\(movie.id)", parameters: params as [String: AnyObject])
        
        Alamofire.request(url.absoluteString).response { response in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            if let data = response.data {
                let json = JSON(data: data)
                if let statusMessage = json[Constants.TMDBResponseKeys.StatusMessage].string {
                    completion(nil, MoviesAPIError.tmdb(statusMessage))
                    return
                }
                completion(json, nil)
            } else {
                completion(nil, MoviesAPIError.noData)
            }
        }
    }
    
    // Fetches videos for the selected movie and calls the completion handlers with videos jsons.
    func fetchVideos(movie: Movie, completion: @escaping ([JSON]?, Error?) -> Void) {
        let params: [String: Any] = [
            Constants.TMDBParameterKeys.APIKey: Constants.TMDBParameterValues.APIKey,
            Constants.TMDBParameterKeys.Language: Constants.TMDBParameterValues.Language,
            ]
        
        let url = TMDBURLFromParameters(path: "/3/movie/\(movie.id)/videos", parameters: params as [String: AnyObject])
        
        Alamofire.request(url.absoluteString).response { response in
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }
            if let data = response.data {
                let json = JSON(data: data)
                if let statusMessage = json[Constants.TMDBResponseKeys.StatusMessage].string {
                    completion(nil, MoviesAPIError.tmdb(statusMessage))
                    return
                }
                if let videosJSON = json[Constants.TMDBResponseKeys.Results].array {
                    completion(videosJSON, nil)
                }
            } else {
                completion(nil, MoviesAPIError.noData)
            }
        }
    }
        
    // Creates TMDB URL based on given parameters and path.
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

