//
//  SettingsViewController.swift
//  Movies
//
//  Created by Maria  on 10/12/17.
//  Copyright © 2017 Maria . All rights reserved.
//

import UIKit

// Static table view controller to select Grid Size.
class SettingsViewController: UITableViewController {
    
    var gridSize: GridSize {
        get {
            let value = UserDefaults.standard.integer(forKey: Constants.Keys.GridSize)
            return GridSize(rawValue: value)!
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        self.navigationController?.navigationBar.isTranslucent = false
        updateState()
    }
    
    @IBAction func onValueChange(_ sender: Any) {
        UserDefaults.standard.set(segmentedControl.selectedSegmentIndex, forKey: Constants.Keys.GridSize)
    }

    func updateState() {
        segmentedControl.selectedSegmentIndex = gridSize.rawValue
    }
    
    @IBAction func onClose(sender: UIBarButtonItem!) {
        dismiss(animated: true, completion: nil)
    }

}
