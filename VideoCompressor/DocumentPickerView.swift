//
//  DocumentPickerView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/16.
//

import Foundation
import SwiftUI
import Photos

struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var progressList: [Float]
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIDocumentPickerDelegate {
        let parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print(urls)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio], asCopy: true)
        controller.modalPresentationStyle = .fullScreen
        controller.shouldShowFileExtensions = true
        controller.allowsMultipleSelection = false
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }
}
