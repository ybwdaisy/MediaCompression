//
//  ActivityViewController.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/23.
//

import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    @Binding var activityItems: [Any]
    
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
