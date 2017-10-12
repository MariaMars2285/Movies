//
//  VideosViewController.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movie: Movie!
    
    var moviesManager = MoviesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("videos movie title \(movie.title)")
        moviesManager.fetchVideos(movie: movie) { (videos, error) in
            for video in videos! {
                print("video....\(video.key)")
            }
        }
    }
}

extension VideosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension VideosViewController: UICollectionViewDelegateFlowLayout {
    
   
    
}
