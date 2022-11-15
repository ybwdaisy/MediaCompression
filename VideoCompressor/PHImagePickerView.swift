//
//  PHImagePickerView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/11.
//

import Foundation
import PhotosUI
import SwiftUI
import Photos

struct PHImagePickerView: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var progressList: [Float]
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
                
                for (index, itemProvider) in itemProviders.enumerated() {
                    self.parent.progressList.append(0.0)
                    itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                        if error != nil {
                            return
                        }
                        guard let url = url else { return }
                        let filename = url.deletingPathExtension().lastPathComponent
                        let inputUrl = URL(fileURLWithPath: NSTemporaryDirectory() + "\(UUID().uuidString).\(url.pathExtension)")
                        try? FileManager.default.copyItem(at: url, to: inputUrl)
                        let compressedUrl = URL(fileURLWithPath: NSTemporaryDirectory() + "\(filename)_\(Int(Date().timeIntervalSince1970)).MP4")

                        DispatchQueue.main.async {
                            self.compressVideo(inputURL: inputUrl, outputURL: compressedUrl, index: index)
                        }
                    }
                }
                self.parent.presentationMode.wrappedValue.dismiss()
                
            } else {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func compressVideo(inputURL: URL, outputURL: URL, index: Int) {
            let urlAsset = AVURLAsset(url: inputURL, options: nil)
            
            guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality) else { return }
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            
            let exportSessionTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                let progress = Float(exportSession.progress)
                self.parent.progressList[index] = progress
            }
            exportSessionTimer.fire()
            
            exportSession.exportAsynchronously {
                switch exportSession.status {
                    case .unknown:
                        break
                    case .waiting:
                        break
                    case .exporting:
                        break
                    case .completed:
                        exportSessionTimer.invalidate()
                        self.saveToAlbum(url: outputURL, index: index)
                    case .failed:
                        break
                    case .cancelled:
                        break
                @unknown default:
                    fatalError()
                }
            }
            
        }
        
        func saveToAlbum(url: URL, index: Int) {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { saved, error in
                if saved {
                    self.parent.progressList[index] = 0.0
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .videos
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }
    
}
