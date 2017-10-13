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
            let value = UserDefaults.standard.integer(forKey: "GridSize")
            return GridSize(rawValue: value)!
        }
    }
    
    @IBOutlet weak var smallGridTableViewCell: UITableViewCell!
    @IBOutlet weak var largeGridTableViewCell: UITableViewCell!

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.set(indexPath.row, forKey: "GridSize")
        updateState()
    }
    
    func updateState() {
        if gridSize == .large {
            largeGridTableViewCell.accessoryType = .checkmark
            smallGridTableViewCell.accessoryType = .none
        } else {
            smallGridTableViewCell.accessoryType = .checkmark
            largeGridTableViewCell.accessoryType = .none
        }
    }
    
    @IBAction func onClose(sender: UIBarButtonItem!) {
        dismiss(animated: true, completion: nil)
    }

}
