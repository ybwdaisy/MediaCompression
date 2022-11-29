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
            let asset = info[.phAsset] as? PHAsset
            var outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(Int(Date().timeIntervalSince1970)).jpg")
            if asset != nil {
                let imageName = asset!.value(forKey: "filename") as! String
                let imageNameArr = imageName.components(separatedBy: ".")
                let fileName = imageNameArr[0]
                let extName = imageNameArr[1]
                outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(fileName)_\(Int(Date().timeIntervalSince1970)).\(extName)")
            }

            let image = info[.originalImage] as? UIImage
            let imageURL = info[.imageURL] as? URL
            let data = image?.jpegData(compressionQuality: 0.5)
            
            let source = CGImageSourceCreateWithData(data as! CFData, nil)
            let type = CGImageSourceGetType(source!)
            let mutableData = NSMutableData(data: data!)
            let destination = CGImageDestinationCreateWithData(mutableData, type!, 1, nil)

            let imageSource = CGImageSourceCreateWithURL(imageURL as! CFURL, nil)
            let imageProperties = CGImageSourceCopyMetadataAtIndex(imageSource!, 0, nil)
            let mutableMetadata = CGImageMetadataCreateMutableCopy(imageProperties!)

            var location = asset?.location
            if location != nil {
                CGImageMetadataSetValueMatchingImageProperty(mutableMetadata!, kCGImagePropertyGPSDictionary, kCGImagePropertyGPSLatitudeRef, "N" as CFTypeRef)
                CGImageMetadataSetValueMatchingImageProperty(mutableMetadata!, kCGImagePropertyGPSDictionary, kCGImagePropertyGPSLatitude, location!.coordinate.latitude as CFTypeRef)
                CGImageMetadataSetValueMatchingImageProperty(mutableMetadata!, kCGImagePropertyGPSDictionary, kCGImagePropertyGPSLongitudeRef, "E" as CFTypeRef)
                CGImageMetadataSetValueMatchingImageProperty(mutableMetadata!, kCGImagePropertyGPSDictionary, kCGImagePropertyGPSLongitude, location!.coordinate.longitude as CFTypeRef)
            }

            CGImageDestinationAddImageAndMetadata(destination!, UIImage(data: data!)!.cgImage!, mutableMetadata, nil)
            CGImageDestinationFinalize(destination!)
            
            try? mutableData.write(to: outputURL)
            
            PHPhotoLibrary.shared().performChanges({
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: outputURL)
                if asset == nil {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let createDate = dateFormatter.date(from: "2022-11-29 09:17:00")
                    assetChangeRequest?.creationDate = createDate
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
