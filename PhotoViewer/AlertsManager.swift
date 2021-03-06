//
//  AlertsManager.swift
//  PhotoViewer
//

import Foundation
import UIKit

class AlertsManager {
    func showAlert(mainViewController: UIViewController, title: String, message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alert.addAction(defaultAction)
            mainViewController.present(alert, animated: true, completion: nil)
        })
    }
}
