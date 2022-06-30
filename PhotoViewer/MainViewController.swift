//
//  ViewController.swift
//  PhotoViewer
//

import UIKit
import Photos

class MainViewController: UIViewController {
    
    @IBOutlet weak var _myTableView: UITableView!
    @IBOutlet weak var _startSelectionButton: UIButton!
    
    public var _selectedMediaTypes = ["Photos : ", "Videos : "]
    private var _selectedPhotos = 0
    private var _selectedVideos = 0
    
    var selectedPhotos: Int {
        get {
            return _selectedPhotos
        }
        set {
            _selectedPhotos = newValue
        }
    }
    
    var selectedVideos: Int {
        get {
            return _selectedVideos
        }
        set {
            _selectedVideos = newValue
        }
    }
    
    override func viewDidLoad() {
        let _ = PHPhotoLibrary.execute(controller: self, onAccessHasBeenGranted: {
        })
        super.viewDidLoad()
        self._myTableView.delegate = self
        self._myTableView.dataSource = self
        self._startSelectionButton.addTarget(self, action: #selector(self.clickedButton), for: .touchUpInside)
    }
    
    @IBAction func clickedButton(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMediaViewController" {
            if let target = segue.destination as? MediaFileViewController {
                target._mainViewController = self
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _selectedMediaTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = _myTableView.dequeueReusableCell(withIdentifier: TableViewCustomCell.cellReuseIdentifier, for: indexPath) as? TableViewCustomCell {
            let item = self._selectedMediaTypes[indexPath.row]
            cell.selectedMediaType?.text = item
            if self._selectedMediaTypes[indexPath.row].contains("Photos") {
                cell.counter?.text = "\(selectedPhotos)"
            } else {
                cell.counter?.text = "\(_selectedVideos)"
            }
            cell.counter?.textColor = .systemPurple
            return cell
        }
        
        return TableViewCustomCell()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
