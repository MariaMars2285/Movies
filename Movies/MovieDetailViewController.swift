//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

class MovieDetailViewController: BaseViewController {
    
    var movie: Movie!
    let movieManager = MoviesManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("movie title is \(movie.title)")
        if movie.detail != nil {
            printDetails()
        } else {
            movieManager.fetchMovieDetails(movie: movie, completion: { (detail, error) in
                guard error == nil else {
                    print("Error")
                    return
                }
                
                self.printDetails()
            })
        }
    }
    
    func printDetails() {
        print(movie.detail?.poster ?? "poster")
        print(movie.detail?.backdrop ?? "backdrop")
        print(movie.detail?.imdbID ?? "IMDB id")
        print(movie.detail?.overview ?? "overview")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideosView" {
            let vc = segue.destination as! VideosViewController
            vc.movie = movie
        }
    }

}
