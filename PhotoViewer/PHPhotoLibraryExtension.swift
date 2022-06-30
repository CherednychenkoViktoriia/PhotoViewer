//
//  PHPhotoLibraryExtension.swift
//  PhotoViewer
//

import Foundation
import Photos
import UIKit

public extension PHPhotoLibrary {
   
   static func execute(controller: UIViewController,
                       onAccessHasBeenGranted: @escaping () -> Void,
                       onAccessHasBeenDenied: (() -> Void)? = nil) {
      
      let onDeniedOrRestricted = onAccessHasBeenDenied ?? {
         let alert = UIAlertController(
            title: "Failed to load media files",
            message: "Please, enable access in Privacy Settings",
            preferredStyle: .alert)
         alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
         alert.addAction(UIAlertAction(
            title: "Settings",
            style: .default,
            handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
               UIApplication.shared.open(settingsURL)
            }
         }))
         DispatchQueue.main.async {
            controller.present(alert, animated: true)
         }
      }

      let status = PHPhotoLibrary.authorizationStatus()
      switch status {
      case .notDetermined:
         onNotDetermined(onDeniedOrRestricted, onAccessHasBeenGranted)
      case .denied, .limited, .restricted:
         onDeniedOrRestricted()
      case .authorized:
         onAccessHasBeenGranted()
      @unknown default:
         fatalError("PHPhotoLibrary - unknown error")
      }
   }
   
}

private func onNotDetermined(_ onDeniedOrRestricted: @escaping (()->Void), _ onAuthorized: @escaping (()->Void)) {
   PHPhotoLibrary.requestAuthorization({ status in
      switch status {
      case .notDetermined:
         onNotDetermined(onDeniedOrRestricted, onAuthorized)
      case .denied, .limited, .restricted:
         onDeniedOrRestricted()
      case .authorized:
         onAuthorized()
      @unknown default:
         fatalError("PHPhotoLibrary - unknown error")
      }
   })
}
