//
//  MediaFileCell.swift
//  PhotoViewer
//

import UIKit
import Photos

class MediaFileViewCell: UICollectionViewCell {
    static let cellReuseIdentifier = "MediaFileViewCell"
    
    @IBOutlet weak var mediaFileView: UIImageView!
    @IBOutlet weak var selectionView: UIImageView!
    @IBOutlet weak var videoIcon: UIImageView!
    
    private var isSelectionModeTurnedOn = false
    
    override var isSelected: Bool {
        didSet {
            if isSelectionModeTurnedOn {
                selectionView.isHidden = !isSelected
                isSelectionModeTurnedOn = false
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaFileView?.image = nil
        selectionView.isHidden = true
    }
    
    func setSelectionMode(_ state: Bool) {
        isSelectionModeTurnedOn = state
    }
}
