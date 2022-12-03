//
//  ImagePickerView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/10.
//

import Foundation
import SwiftUI
import Photos

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var progressList: [Float]
    @Binding var compressFinished: Bool
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let assetResult = PHAsset.fetchAssets(withALAssetURLs: [info[.referenceURL]] as! [URL], options: nil)
            let imageInfo = assetResult.firstObject
            let creationDate = imageInfo?.value(forKey: "creationDate")
            let imageName = imageInfo?.value(forKey: "filename") as! String
            
            let imageNameArr = imageName.components(separatedBy: ".")
            let fileName = imageNameArr[0]
            let extName = imageNameArr[1]
            let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(fileName ?? "")_\(Int(Date().timeIntervalSince1970)).\(extName)")

            let image = info[.originalImage] as? UIImage
            let imageURL = info[.imageURL] as? URL
            let data = image?.jpegData(compressionQuality: 0.5)

            let source = CGImageSourceCreateWithData(data! as CFData, nil)
            let type = CGImageSourceGetType(source!)
            let mutableData = NSMutableData(data: data!)
            let destination = CGImageDestinationCreateWithData(mutableData, type!, 1, nil)

            let imageSource = CGImageSourceCreateWithURL(imageURL! as CFURL, nil)
            let imageProperties = CGImageSourceCopyMetadataAtIndex(imageSource!, 0, nil)
            let mutableMetadata = CGImageMetadataCreateMutableCopy(imageProperties!)

            CGImageDestinationAddImageAndMetadata(destination!, UIImage(data: data!)!.cgImage!, mutableMetadata, nil)
            CGImageDestinationFinalize(destination!)

            try? mutableData.write(to: outputURL)
            
            PHPhotoLibrary.shared().performChanges({
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: outputURL)
                if creationDate != nil {
                    assetChangeRequest?.creationDate = creationDate as? Date
                }
            }) { saved, error in
                if saved {
                    self.parent.compressFinished = true
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController();
        controller.delegate = context.coordinator;
        return controller;
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
}
