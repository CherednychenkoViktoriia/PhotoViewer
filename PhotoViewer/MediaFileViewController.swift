//
//  CollectionViewController.swift
//  PhotoViewer
//

import UIKit
import Photos

typealias MediaFile = (mediaFile: PHAsset, selected: Bool, isVideo: Bool)

class MediaFileViewController: UICollectionViewController {
    static let reuseIdentifier = "goToMediaViewController"
    
    private var _mediaFiles = [MediaFile]()
    private var _imageManager = PHImageManager.default()
    private var _imageRequestOptions = PHImageRequestOptions()
    private var _videoRequestOptions = PHVideoRequestOptions()
    private var _fetchOptions = PHFetchOptions()
    private var _alertsManager = AlertsManager()
    private var _isSelectionModeTurnedOn = false
    private let _cellsCount = 3
    private let _offset: CGFloat = 2.0
    private var _selectedPhotos = 0
    private var _selectedVideos = 0
    private let _fetchLimit = 20
    
    internal var _mainViewController = MainViewController()
    
    @IBOutlet weak var _myCollectionView: UICollectionView!
    @IBOutlet weak var _okButton: UIBarButtonItem!
    @IBOutlet weak var _cancelButton: UIBarButtonItem!
    
    init(collectionViewLayout: UICollectionViewFlowLayout) {
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        _mediaFiles = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: _myCollectionView.frame.width/CGFloat(_cellsCount), height: _myCollectionView.frame.width/CGFloat(_cellsCount))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        _myCollectionView.collectionViewLayout = layout
        
        _myCollectionView.dataSource = self
        _myCollectionView.delegate = self
        self.clearsSelectionOnViewWillAppear = false
        
        _myCollectionView.canCancelContentTouches = false
        _myCollectionView.allowsMultipleSelection = true
        
        _isSelectionModeTurnedOn = true
        
        self._imageRequestOptions = setImageRequestOptions()
        self._videoRequestOptions = setVideoRequestOptions()
        getMediaFiles()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        _selectedPhotos = 0
        _selectedVideos = 0
        updateSelectedMediaFilesCounter()
        _mainViewController._myTableView.reloadData()
        _alertsManager.showAlert(mainViewController: _mainViewController, title: "Selection canceled by user", message: "")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        _mainViewController._myTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _mediaFiles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = _myCollectionView.dequeueReusableCell(withReuseIdentifier: MediaFileViewCell.cellReuseIdentifier, for: indexPath) as? MediaFileViewCell {
            let item = _mediaFiles[indexPath.row]
            cell.selectionView.isHidden = !item.selected
            
            let itemWidth = _myCollectionView.frame.width / CGFloat(_cellsCount)
            let itemHeight = itemWidth
            let spacing = CGFloat(_cellsCount + 1) * _offset / CGFloat(_cellsCount)
            let itemSize = CGSize(width: itemWidth - spacing, height: itemHeight - (_offset * 2))
            
            _imageManager.requestImage(for: item.mediaFile, targetSize: itemSize, contentMode: .aspectFill, options: _imageRequestOptions) { (image, _) in
                if let unwrappedImage = image {
                    cell.mediaFileView.image = unwrappedImage
                }
            }
            
            if !item.isVideo {
                cell.videoIcon.isHidden = true
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if _isSelectionModeTurnedOn {
            let cell = collectionView.cellForItem(at: indexPath) as? MediaFileViewCell
            cell?.setSelectionMode(true)
            cell?.isSelected = true
            self._mediaFiles[indexPath.row].selected = true
            increaseSelectedMediaFilesCounter(mediaFile: self._mediaFiles[indexPath.row])
            updateSelectedMediaFilesCounter()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if _isSelectionModeTurnedOn {
            let cell = collectionView.cellForItem(at: indexPath) as? MediaFileViewCell
            cell?.setSelectionMode(true)
            cell?.isSelected = false
            self._mediaFiles[indexPath.row].selected = false
            decreaseSelectedMediaFilesCounter(mediaFile: self._mediaFiles[indexPath.row])
            updateSelectedMediaFilesCounter()
        }
    }
    
    // MARK: Functions for getting media files
    
    func getMediaFiles() {
        _fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        _fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        _fetchOptions.fetchLimit = _fetchLimit
        let assets = PHAsset.fetchAssets(with: _fetchOptions)
        if assets.count > 0 {
            for i in 0..<assets.count {
                let asset = assets.object(at: i)
                let isVideo = asset.mediaType == .video ? true : false
                self._mediaFiles.append(MediaFile(asset, false, isVideo))
            }
        } else {
            print("No media files to display")
        }
    }
    
    private func setImageRequestOptions() -> PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .none
        return options
    }
    
    private func setVideoRequestOptions() -> PHVideoRequestOptions {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        return options
    }
    
    // MARK: Counter functions
    
    func increaseSelectedMediaFilesCounter(mediaFile: MediaFile) {
        if mediaFile.selected && mediaFile.mediaFile.mediaType == PHAssetMediaType.image {
            _selectedPhotos += 1
        }
        if mediaFile.selected && mediaFile.mediaFile.mediaType == PHAssetMediaType.video {
            _selectedVideos += 1
        }
    }
    
    func decreaseSelectedMediaFilesCounter(mediaFile: MediaFile) {
        if !mediaFile.selected && mediaFile.mediaFile.mediaType == PHAssetMediaType.image {
            _selectedPhotos -= 1
        }
        if !mediaFile.selected && mediaFile.mediaFile.mediaType == PHAssetMediaType.video {
            _selectedVideos -= 1
        }
    }
    
    func updateSelectedMediaFilesCounter() {
        _mainViewController.selectedPhotos = _selectedPhotos
        _mainViewController.selectedVideos = _selectedVideos
    }
}
