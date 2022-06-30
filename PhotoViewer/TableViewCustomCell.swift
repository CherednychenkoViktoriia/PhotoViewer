//
//  TableViewCustomCell.swift
//  PhotoViewer
//
//  Created by Viktoriia Cherednychenko on 22.06.2022.
//

import Foundation
import UIKit

class TableViewCustomCell: UITableViewCell {
    static let cellReuseIdentifier = "TableViewCustomCell"
    
    @IBOutlet weak var selectedMediaType: UILabel!
    @IBOutlet weak var counter: UILabel!
    
}
