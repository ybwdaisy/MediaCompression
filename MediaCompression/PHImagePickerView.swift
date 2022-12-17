//
//  PHImagePickerView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/11.
//

import Foundation
import PhotosUI
import SwiftUI
import Photos

struct PHImagePickerView: UIViewControllerRepresentable {
    @Binding var progressList: [Float]
    @Binding var compressFinished: Bool
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PHImagePickerView
        
        init(parent: PHImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if !results.isEmpty {
                let total = results.count
                let itemProviders: [NSItemProvider] = results.map(\.itemProvider)
                
                for (index, itemProvider) in itemProviders.enumerated() {
                    self.parent.progressList.append(0.0)
                    itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                        if error != nil {
                            return
                        }
                        guard let url = url else { return }
                        let inputUrl = fileTmpURL(url: url)
                        try? FileManager.default.copyItem(at: url, to: inputUrl)
                        let compressedUrl = fileOutputURL(url: url)
                        
                        var fileType: AVFileType = .mov
                        
                        if url.pathExtension == "mp4" {
                            fileType = .mp4
                        }

                        DispatchQueue.main.async {
                            self.compressVideo(inputURL: inputUrl, outputURL: compressedUrl, index: index, fileType: fileType, finished: index == total - 1)
                        }
                    }
                }
                self.parent.presentationMode.wrappedValue.dismiss()
                
            } else {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func compressVideo(inputURL: URL, outputURL: URL, index: Int, fileType: AVFileType, finished: Bool) {
            let urlAsset = AVURLAsset(url: inputURL, options: nil)
            let creationDate = urlAsset.creationDate?.dateValue
            
            guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetHighestQuality) else { return }
            exportSession.outputURL = outputURL
            exportSession.outputFileType = fileType
            
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
                        self.saveToAlbum(url: outputURL, index: index, creationDate: creationDate!, finished: finished)
                        exportSessionTimer.invalidate()
                    case .failed:
                        break
                    case .cancelled:
                        break
                @unknown default:
                    fatalError()
                }
            }
            
        }
        
        func saveToAlbum(url: URL, index: Int, creationDate: Any, finished: Bool) {
            PHPhotoLibrary.shared().performChanges({
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                if creationDate != nil {
                    assetChangeRequest?.creationDate = creationDate as? Date;
                }
            }) { saved, error in
                if saved {
                    self.parent.progressList[index] = 0.0
                }
                if finished {
                    self.parent.compressFinished = true
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
