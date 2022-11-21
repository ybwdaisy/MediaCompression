//
//  ImagePickerView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/10.
//

import Foundation
import SwiftUI
import Photos

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var progressList: [Float]
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let asset = info[.phAsset] as? PHAsset
            var outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(Int(Date().timeIntervalSince1970)).jpg")
            var location = asset?.location
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
            
            if location != nil {
                CGImageMetadataSetValueMatchingImageProperty(mutableMetadata!, kCGImagePropertyGPSDictionary, kCGImagePropertyGPSLatitudeRef, "N" as CFTypeRef)
                CGImageMetadataSetValueMatchingImageProperty(mutableMetadata!, kCGImagePropertyGPSDictionary, kCGImagePropertyGPSLatitude, location!.coordinate.latitude as CFTypeRef)
                CGImageMetadataSetValueMatchingImageProperty(mutableMetadata!, kCGImagePropertyGPSDictionary, kCGImagePropertyGPSLongitudeRef, "E" as CFTypeRef)
                CGImageMetadataSetValueMatchingImageProperty(mutableMetadata!, kCGImagePropertyGPSDictionary, kCGImagePropertyGPSLongitude, location!.coordinate.longitude as CFTypeRef)
            }
            
            // TODO: set asset.creationDate
            
            CGImageDestinationAddImageAndMetadata(destination!, UIImage(data: data!)!.cgImage!, mutableMetadata, nil)
            CGImageDestinationFinalize(destination!)
            
            try? mutableData.write(to: outputURL)
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: outputURL)
            }) { saved, error in
                if saved {
                    let alert = UIAlertController(title: NSLocalizedString("The compressed image has been saved to the album.", comment: ""), message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    }))
                    DispatchQueue.main.async {
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
                    }
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
