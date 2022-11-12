//
//  PHImagePickerView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/11.
//

import Foundation
import PhotosUI
import SwiftUI

struct PHImagePickerView: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PHImagePickerView
        
        init(parent: PHImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if !results.isEmpty {
                parent.images = []
                let itemProviders: [NSItemProvider] = results.map(\.itemProvider)
                let itemProvider = itemProviders[0]
                itemProvider.loadObject(ofClass: UIImage.self) { (image: NSItemProviderReading?, error: Error?) in
                    if image != nil {
                        self.parent.images.append(image! as! UIImage)
                    }
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            } else {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .images
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }
    
}
