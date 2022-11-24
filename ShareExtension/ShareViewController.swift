//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by ybw-macbook-pro on 2022/11/24.
//

import UIKit
import Social
import Photos

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        guard let inputItems = self.extensionContext?.inputItems.map({ $0 as? NSExtensionItem }) else {
            self.extensionContext?.cancelRequest(withError: NSError())
            return
        }
        
        for inputItem in inputItems {
            guard let itemProviders = inputItem?.attachments else { return }
            for itemProvider in itemProviders {
                if (itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)) {
                    itemProvider.loadDataRepresentation(for: UTType.image) { data, error in
                        if (error != nil) { return }
                        guard let imageData = data else { return }
                        // TODO: get extension
                        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(Int(Date().timeIntervalSince1970)).jpg")
                        // TODO: compress image
                        try! imageData.write(to: outputURL)
                        
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: outputURL)
                        }) { saved, error in
                            if saved {
                                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                            }
                        }
                    }
                }
                if (itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier)) {
                    itemProvider.loadDataRepresentation(for: UTType.movie) { data, error in
                        if (error != nil) { return }
                        guard let videoData = data else { return }
                        // TODO: get extension
                        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(Int(Date().timeIntervalSince1970)).mov")
                        // TODO: compress video
                        try! videoData.write(to: outputURL)
                        
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
                        }) { saved, error in
                            if saved {
                                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                            }
                        }
                    }
                }
            }
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
