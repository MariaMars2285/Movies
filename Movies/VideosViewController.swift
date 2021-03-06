//
//  VideosViewController.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class VideosViewController: CollectionBaseViewController {
    
    var movie: Movie!
    var moviesManager = MoviesManager()
    var imageDownloader = ImageDownloader()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Lazy initialization of FetchedResultsController to fetch videos for the selected movie from Core Data.
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Video> in
        let fetchRequest = NSFetchRequest<Video>(entityName: Constants.EntityNames.Video)
        fetchRequest.predicate = NSPredicate(format: "movie == %@", movie)
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error")
        }
        if fetchedResultsController.fetchedObjects == nil {
            self.activityIndicator.startAnimating()
        }
        fetchVideos()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView.reloadData()
    }
    
    // Fetch Videos using the Movie Manager.
    func fetchVideos() {
        moviesManager.fetchVideos(movie: movie) { (_, error) in
            if error != nil {
                self.alertError(error: error)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}

extension VideosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.VideoGridCell, for: indexPath) as! VideoGridCell
        let video = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = video.name
        if let data = video.thumbnail {
            cell.indicatorView.stopAnimating()
            cell.imageView.image = UIImage(data: data)
        } else {
            cell.indicatorView.startAnimating()
            imageDownloader.downloadThumbnail(forVideo: video)
        }
        return cell
    }
}

extension VideosViewController: UICollectionViewDelegateFlowLayout {
    
    // Returns size of grid item by subtracting the space from width and dividing by number of items per row.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            let width = (collectionView.bounds.width - 20) / 3
            let height = width + 40
            return CGSize(width: width, height: height)
        } else {
            let width = (collectionView.bounds.width - 15) / 2
            let height = width + 40
            return CGSize(width: width, height: height)
        }
    }
    
}

extension VideosViewController: UICollectionViewDelegate {
    // Opens the youtube URL in a Safari View Controller.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let video = fetchedResultsController.object(at: indexPath)
        if let url = video.youtubeURL() {
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true, completion: nil)
        } else {
            showErrorAlert(title: "Error", message: "Current trailer doesn't contain a valid URL.")
        }
    }
}
