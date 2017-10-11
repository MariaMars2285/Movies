//
//  MoviesViewController.swift
//  Movies
//
//  Created by Maria  on 10/10/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import CoreData

class MoviesViewController: BaseViewController {
    
    var gridSize: GridSize {
        get {
            let value = UserDefaults.standard.integer(forKey: "GridSize")
            return GridSize(rawValue: value)!
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    var refresher:UIRefreshControl!
    private var pageLoaded = 0
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths : [IndexPath]!
    var updatedIndexPaths : [IndexPath]!
    var moviesManager = MoviesManager()
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Movie> in
        let fetchRequest = NSFetchRequest<Movie>(entityName: Constants.EntityNames.Movie)
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(fetchFirstPage), for: .valueChanged)
        self.collectionView.addSubview(refresher)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error")
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
    
    @objc func fetchFirstPage() {
        self.refresher.beginRefreshing()
        fetchMovies(page: 1)
    }
    
    func fetchMovies(page: Int) {
        moviesManager.fetchMovies(page: page) { (movies, error) in
            // TODO: Handle Error Conditions.
            self.refresher.endRefreshing()
            guard error != nil else {
                //TODO: Show Alert
                return
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


