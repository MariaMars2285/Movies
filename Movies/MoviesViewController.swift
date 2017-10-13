//
//  MoviesViewController.swift
//  Movies
//
//  Created by Maria  on 10/10/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import CoreData

class MoviesViewController: CollectionBaseViewController {
    
    // Grid Size based on value from setting.
    var gridSize: GridSize {
        get {
            let value = UserDefaults.standard.integer(forKey: "GridSize")
            return GridSize(rawValue: value)!
        }
    }

    var refresher: UIRefreshControl!
    private var pageLoaded = 0
    
    var moviesManager = MoviesManager()
    var imageDownloader = ImageDownloader()
    
    // Lazy initialization of FetchedResultsController to fetch movies from Core Data.
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Movie> in
        let fetchRequest = NSFetchRequest<Movie>(entityName: Constants.EntityNames.Movie)
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Setting up pull to refresh for collection view.
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(fetchFirstPage), for: .valueChanged)
        self.collectionView.addSubview(refresher)
        self.collectionView.refreshControl = refresher
        self.collectionView.layoutIfNeeded()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error")
        }
        if fetchedResultsController.fetchedObjects == nil || fetchedResultsController.fetchedObjects!.count == 0  {
            self.refresher.beginRefreshing()
        }
        fetchMovies(page: pageLoaded + 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView.reloadData()
    }
    
    // Fetch first page on full to refresh.
    @objc func fetchFirstPage() {
        self.refresher.beginRefreshing()
        fetchMovies(page: 1)
    }
    
    // Fetch movies from TMDB.
    func fetchMovies(page: Int) {
        moviesManager.fetchMovies(page: page) { (movies, error) in
            self.refresher.endRefreshing()
            guard error == nil else {
                self.alertError(error: error)
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetail" {
            let vc = segue.destination as! MovieDetailViewController
            if let indexPaths = collectionView.indexPathsForSelectedItems, let first = indexPaths.first {
                let movie = fetchedResultsController.object(at: first)
                vc.movie = movie
                collectionView.deselectItem(at: first, animated: true)
            }
        }
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.MovieGridCell, for: indexPath) as! MovieGridCell
        let movie = fetchedResultsController.object(at: indexPath)
        if let data = movie.posterData {
            cell.indicatorView.stopAnimating()
            cell.imageView.image = UIImage(data: data)
        } else {
            cell.indicatorView.startAnimating()
            imageDownloader.downloadPoster(forMovie: movie)
        }
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    // Returns size of grid item based on user settings.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5.0
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            if gridSize == .small {
                let width = (collectionView.bounds.width - 5 * spacing) / 4
                return CGSize(width: width, height: width * 3.0 / 2)
            } else {
                let width = (collectionView.bounds.width - 4 * spacing) / 3
                return CGSize(width: width, height: width * 3.0 / 2)
            }
        } else {
            if gridSize == .small {
                let width = (collectionView.bounds.width - 4 * spacing) / 3
                return CGSize(width: width, height: width * 3.0 / 2)
            } else {
                let width = (collectionView.bounds.width - 3 * spacing) / 2
                return CGSize(width: width, height: width * 3.0 / 2)
            }
        }
    }
}


