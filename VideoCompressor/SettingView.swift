//
//  SettingView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/21.
//

import SwiftUI

struct SettingView: View {
    @State private var showClearCacheAlert = false
    @State private var cacheSize: String = ""

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(Color(UIColor.systemRed))
                    Text("Clear the cache")
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                    Text(cacheSize)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(UIColor.systemGray2))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10.0)
                .onTapGesture {
                    showClearCacheAlert = true
                }
                .alert(isPresented: $showClearCacheAlert) {
                    Alert(
                        title: Text("Clear the cache"),
                        message: Text("Temporary files generated during the compression process will be cleared."),
                        primaryButton: .destructive(Text("Clear"), action: clearCache),
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
                Spacer()
            }
            .padding(EdgeInsets(top: CGFloat(20.0), leading: 20.0, bottom: 0, trailing: 20.0))
        }
        .navigationTitle("Setting")
        .onAppear {
            cacheSize = self.calculateCache()
        }
    }
    
    func calculateCache() -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        let files = FileManager.default.subpaths(atPath: cachePath!)
        
        var size: Float = 0
        
        for file in files! {
            let path = cachePath?.appending("/\(file)")
            let folder = try! FileManager.default.attributesOfItem(atPath: path!)
            for (key, value) in folder {
                if key == FileAttributeKey.size {
                    size += (value as AnyObject).floatValue
                }
            }
        }
        
        return formatFileSize(bytes: size)
    }
    
    func clearCache() {
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        let files = FileManager.default.subpaths(atPath: cachePath!)
        
        for file in files! {
            let path = cachePath?.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                try! FileManager.default.removeItem(atPath: path!)
            }
        }
        cacheSize = ""
    }
    
    func formatFileSize(bytes: Float) -> String {
        if (bytes < 1024) {
            return "\(bytes) B"
        }
        let exp = Int(log2(Double(bytes)) / log2(1024.0))
        let unit = ["KB", "MB", "GB", "TB", "PB", "EB"][exp - 1]
        
        let number = Double(bytes) / pow(1024, Double(exp))
        if (exp <= 1 || number >= 100) {
            return String(format: "%.0f %@", number, unit)
        } else {
            return String(format: "%.1f %@", number, unit).replacingOccurrences(of: ".0", with: "")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}


