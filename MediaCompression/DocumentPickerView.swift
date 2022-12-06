//
//  DocumentPickerView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/16.
//

import Foundation
import SwiftUI
import Photos

struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var progressList: [Float]
    @Binding var isSharePresented: Bool
    @Binding var activityItems: [Any]
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIDocumentPickerDelegate {
        let parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let total = urls.count
            for (index, url) in urls.enumerated() {
                self.parent.progressList.append(0.0)
                self.parent.activityItems.append(url)
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
                            self.parent.activityItems[index] = outputURL
                            self.parent.progressList[index] = 0.0
                            if index == total - 1 {
                                self.parent.isSharePresented = true
                            }
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
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio], asCopy: true)
        controller.modalPresentationStyle = .fullScreen
        controller.shouldShowFileExtensions = true
        controller.allowsMultipleSelection = true
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }
}
