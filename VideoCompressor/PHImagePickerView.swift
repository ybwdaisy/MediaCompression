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
    @Binding var isPresented: Bool
    @Binding var images: [UIImage]
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PHImagePickerView
        
        init(parent: PHImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if !results.isEmpty {
                parent.images = []
            }
            let itemProviders: [NSItemProvider] = results.map(\.itemProvider)
            let itemProvider = itemProviders[0]
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    self.parent.images.append((image as? UIImage)!)
                    self.parent.isPresented = false;
                }
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
