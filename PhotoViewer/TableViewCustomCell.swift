//
//  TableViewCustomCell.swift
//  PhotoViewer
//

import Foundation
import UIKit

class TableViewCustomCell: UITableViewCell {
    static let cellReuseIdentifier = "TableViewCustomCell"
    
    @IBOutlet weak var selectedMediaType: UILabel!
    @IBOutlet weak var counter: UILabel!
    
}
