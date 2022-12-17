//
//  Utils.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/12/6.
//

import Foundation
import Photos
import SwiftUI


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

func openSettings() -> Void {
    guard let url = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        UIApplication.shared.openURL(url)
    }
}

func getVersion() -> String {
    let infoDictionary = Bundle.main.infoDictionary
    let version = (infoDictionary?["CFBundleShortVersionString"] as? String)!
    let buildNumber = (infoDictionary?["CFBundleVersion"] as? String)!
    return "\(version)(\(buildNumber))"
}

func calculateCache() -> String {
    let tmpPath = NSHomeDirectory() + "/tmp"
    let files = FileManager.default.subpaths(atPath: tmpPath)
    var size: Float = 0
    
    for file in files! {
        let path = tmpPath.appending("/\(file)")
        let folder = try! FileManager.default.attributesOfItem(atPath: path)
        for (key, value) in folder {
            if key == FileAttributeKey.size {
                size += (value as AnyObject).floatValue
            }
        }
    }
    
    return formatFileSize(bytes: size)
}

func clearCache() {
    let tmpPath = NSHomeDirectory() + "/tmp"
    let files = FileManager.default.subpaths(atPath: tmpPath)
    
    for file in files! {
        let path = tmpPath.appending("/\(file)")
        if FileManager.default.fileExists(atPath: path) {
            try! FileManager.default.removeItem(atPath: path)
        }
    }
}

func formatFileSize(bytes: Float) -> String {
    if (bytes < 1024) {
        return "\(bytes) B"
    }
    let exp = Int(log2(Double(bytes)) / log2(1024.0))
    let unit = ["KB", "MB", "GB", "TB", "PB", "EB"][exp - 1]
    
    let number = Double(bytes) / pow(1024, Double(exp))
    if (exp <= 1 || number >= 100) {
        return String(format: "%.0f %@", number, unit)
    } else {
        return String(format: "%.1f %@", number, unit).replacingOccurrences(of: ".0", with: "")
    }
}

func fileTmpURL(url: URL) -> URL {
    return URL(fileURLWithPath: NSTemporaryDirectory() + "\(UUID().uuidString).\(url.pathExtension)")
}

func fileOutputURL(url: URL) -> URL {
    let fileName = url.deletingPathExtension().lastPathComponent
    return URL(fileURLWithPath: NSTemporaryDirectory() + "\(fileName)_\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)")
}
