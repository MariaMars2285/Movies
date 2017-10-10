//
//  MoviesViewController.swift
//  Movies
//
//  Created by Maria  on 10/10/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

enum GridSize {
    case small
    case large
}

class MoviesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let moviesAPI = MoviesAPI()
    var movies = [Movie]()
    var gridSize = GridSize.large
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesAPI.fetchMovies { (movies, error) in
            // TODO: Handle Error Conditions.
            self.movies = movies!
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView.reloadData()
    }

}

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        let movie = movies[indexPath.item]
        cell.titleLabel.text = movie.title
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            if gridSize == .small {
                let width = collectionView.bounds.width / 4 - 1
                return CGSize(width: width, height: width)
            } else {
                let width = collectionView.bounds.width / 3 - 1
                return CGSize(width: width, height: width)
            }
        } else {
            if gridSize == .small {
                let width = collectionView.bounds.width / 3 - 1
                return CGSize(width: width, height: width)
            } else {
                let width = collectionView.bounds.width / 2 - 1
                return CGSize(width: width, height: width)
            }
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}


