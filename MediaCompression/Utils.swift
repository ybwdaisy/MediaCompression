//
//  Utils.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/12/6.
//

import Foundation
import Photos


func photoLibraryUsagePermissions(authorizedBlock: () -> Void, deniedBlock: () -> Void) {
    let authorizationStatus = PHPhotoLibrary.authorizationStatus()
    if (authorizationStatus == .notDetermined) {
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            
        }
    } else if (authorizationStatus == .authorized) {
        authorizedBlock()
    } else {
        deniedBlock()
    }
    
}

func cameraUsagePermissions(authorizedBlock: () -> Void, deniedBlock: () -> Void) {
    let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    if (authorizationStatus == .notDetermined) {
        AVCaptureDevice.requestAccess(for: .video) { (granted: Bool) in
            
        }
    } else if (authorizationStatus == .authorized) {
        authorizedBlock()
    } else {
        deniedBlock()
    }
}
