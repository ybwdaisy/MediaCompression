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
                        Task {
                            await self.compressVideo(inputURL: inputUrl, outputURL: compressedUrl)
                            self.parent.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            } else {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func compressVideo(inputURL: URL, outputURL: URL) async {
            let urlAsset = AVURLAsset(url: inputURL, options: nil)
            
            let metadata = try? await urlAsset.load(.metadata)
            var newMetadata: [AVMetadataItem] = [];
            
            for item in metadata ?? [] {
                let data = AVMutableMetadataItem()
                data.keySpace = AVMetadataKeySpace.quickTimeMetadata
                data.key = item.key
                data.identifier = item.identifier
                data.value = try? await item.load(.value)
                newMetadata.append(data)
            }
            
            let title = AVMutableMetadataItem()
            title.keySpace = AVMetadataKeySpace.quickTimeMetadata
            title.key = AVMetadataKey.quickTimeMetadataKeyTitle as any NSCopying & NSObjectProtocol
            title.identifier = AVMetadataIdentifier.quickTimeMetadataTitle
            title.value = "this is custom text" as any NSCopying & NSObjectProtocol
            
            newMetadata.append(title)
            
            for item in newMetadata ?? [] {
                print(item)
            }
            
            guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality) else { return }
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            exportSession.metadata = newMetadata
            
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
                    let alert = UIAlertController(title: NSLocalizedString("The compressed video has been saved to the album.", comment: ""), message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    }))
                    DispatchQueue.main.async {
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
                    }
                    self.parent.progress = 0.0;
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .videos
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }
    
}
