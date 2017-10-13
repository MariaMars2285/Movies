//
//  MovieGridCell.swift
//  Movies
//
//  Created by Maria  on 10/11/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

// UICollectionViewCell for rendering movies.

class MovieGridCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // Based on : https://stackoverflow.com/questions/13505379/adding-rounded-corner-and-drop-shadow-to-uicollectionviewcell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 4.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.masksToBounds = true
    }
}
