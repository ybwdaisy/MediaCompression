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
            for (index, url) in urls.enumerated() {
                self.parent.progressList.append(0.0)
                let fileName = url.deletingPathExtension().lastPathComponent
                let inputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(UUID().uuidString).\(url.pathExtension)")
                try? FileManager.default.copyItem(at: url, to: inputURL)
                let outputURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(fileName)_\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)")
                
                let urlAsset = AVURLAsset(url: inputURL, options: nil)
                guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetAppleM4A) else { return }
                exportSession.outputURL = outputURL
                exportSession.outputFileType = .m4a
                
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
                            self.parent.progressList[0] = 0.0
                            self.shareFile(url: outputURL)
                        case .failed:
                            break
                        case .cancelled:
                            break
                    @unknown default:
                        fatalError()
                    }
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func shareFile(url: URL) {
            let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.present(activityController, animated: true)
            }
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
