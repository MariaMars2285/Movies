//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit
import SafariServices

class MovieDetailViewController: BaseViewController {
    
    var movie: Movie!
    let movieManager = MoviesManager()
    let imageDownloader = ImageDownloader()
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var videosButton: UIButton!
    @IBOutlet weak var imdbButton: UIButton!
    @IBOutlet weak var videoBarButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if movie.detail != nil {
            setDetails()
        } else {
            activityIndicator.startAnimating()
            // Fetches the movie details for the selected movie.
            movieManager.fetchMovieDetails(movie: movie, completion: { (detail, error) in
                self.activityIndicator.stopAnimating()
                guard error == nil else {
                    self.alertError(error: error)
                    return
                }
                self.setDetails()
            })
        }
    }
    
    @IBAction func onHomePageClick(_ sender: Any) {
        if let url = movie.detail?.homepageURL() {
            openURL(url: url)
        } else {
            showErrorAlert(title: "Error", message: "Invalid Home Page URL!.")
        }
    }
    
    @IBAction func onVideoClick(_ sender: Any) {
        performSegue(withIdentifier: "VideosView", sender: nil)
    }
    
    @IBAction func onIMDBClick(_ sender: Any) {
        if let url = movie.detail?.imdbURL() {
            openURL(url: url)
        } else {
            showErrorAlert(title: "Error", message: "Invalid IMDB Id!")
        }
    }
    
    // Opens the URL in Safari View Controller.
    func openURL(url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    // Sets the values in UI View based on movie details.
    func setDetails() {
        if let detail = movie.detail {
            titleLabel.text = detail.title
            overviewLabel.text = detail.overview
            if let data = movie.posterData {
                posterImageView.image = UIImage(data: data)
            }
            if let backdropData = detail.backdropData {
                backdropImageView.image = UIImage(data: backdropData)
            } else {
                fetchBackdropImage()
            }
            homepageButton.isEnabled = detail.homepage != "" && detail.homepage != nil
            imdbButton.isEnabled = detail.imdbID != nil && detail.imdbID != ""
        }
    }
    
    // Fetches the backdrop image using Image Downloader.
    func fetchBackdropImage() {
        imageDownloader.downloadBackDrop(forMovieDetail: movie.detail!) { (success) in
            self.setDetails()
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideosView" {
            let vc = segue.destination as! VideosViewController
            vc.movie = movie
        }
    }

}
