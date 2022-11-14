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
    @Binding var progress: Float
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
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url: URL?, error: Error?) in
                    if error != nil {
                        return
                    }
                    guard let url = url else { return }
                    let filename = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                    let inputUrl = URL(fileURLWithPath: NSTemporaryDirectory() + filename)
                    try? FileManager.default.copyItem(at: url, to: inputUrl)
                    let compressedUrl = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
                    
                    DispatchQueue.main.async {
                        self.compressVideo(inputURL: inputUrl, outputURL: compressedUrl)
                        self.parent.presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func compressVideo(inputURL: URL, outputURL: URL) {
            let urlAsset = AVURLAsset(url: inputURL, options: nil)
            guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else { return }
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            
            let exportSessionTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                let progress = Float(exportSession.progress)
                self.parent.progress = progress;
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
                        self.saveToAlbum(url: outputURL)
                    case .failed:
                        break
                    case .cancelled:
                        break
                @unknown default:
                    fatalError()
                }
            }
            
        }
        
        func saveToAlbum(url: URL) {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { saved, error in
                if saved {
                    self.showAlert(message: "The compressed video has been saved to the album.")
                    self.parent.progress = 0.0;
                }
            }
        }
        
        func showAlert(message: String) {
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .videos
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }
    
}
