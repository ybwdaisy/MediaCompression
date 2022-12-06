//
//  SettingView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/21.
//

import SwiftUI

struct SettingView: View {
    @State private var showClearCacheAlert = false
    @State private var cacheSize: String = ""
    @State private var isSharePresented: Bool = false
    @State private var activityItems: [Any] = []
    @State private var version: String = ""

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(Color(UIColor.systemRed))
                    Text("Clear the Cache")
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
                HStack {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color(UIColor.systemBlue))
                    Text("Open App Settings")
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(UIColor.systemGray2))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10.0)
                .onTapGesture {
                    openSettings()
                }
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color(UIColor.systemBlue))
                    Text("Share with Friends")
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(UIColor.systemGray2))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10.0)
                .onTapGesture {
                    isSharePresented = true
                    activityItems = ["Media Compression"]
                }
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color(UIColor.systemBlue))
                    Text("Version")
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                    Text(version)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(UIColor.systemGray2))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10.0)
                Spacer()
            }
            .padding(EdgeInsets(top: CGFloat(20.0), leading: 20.0, bottom: 0, trailing: 20.0))
            .alert(isPresented: $showClearCacheAlert) {
                Alert(
                    title: Text("Clear the Cache"),
                    message: Text("Temporary files generated during the compression process will be cleared."),
                    primaryButton: .destructive(Text("Clear"), action: submitClearCache),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
            .sheet(isPresented: $isSharePresented, onDismiss: nil) {
                ActivityViewController(activityItems: $activityItems)
            }
        }
        .navigationTitle("Setting")
        .onAppear {
            cacheSize = self.calculateCache()
            version = self.getVersion()
        }
    }
    
    private func openSettings() -> Void {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func getVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary
        let version = (infoDictionary?["CFBundleShortVersionString"] as? String)!
        let buildNumber = (infoDictionary?["CFBundleVersion"] as? String)!
        return "\(version)(\(buildNumber))"
    }
    
    private func submitClearCache() {
        clearCache()
        cacheSize = calculateCache()
    }
    
    private func calculateCache() -> String {
        let tmpPath = NSHomeDirectory() + "/tmp"
        let files = FileManager.default.subpaths(atPath: tmpPath)
        var size: Float = 0
        
        for file in files! {
            let path = tmpPath.appending("/\(file)")
            let folder = try! FileManager.default.attributesOfItem(atPath: path)
            for (key, value) in folder {
                if key == FileAttributeKey.size {
                    size += (value as AnyObject).floatValue
                }
            }
        }
        
        return formatFileSize(bytes: size)
    }
    
    private func clearCache() {
        let tmpPath = NSHomeDirectory() + "/tmp"
        let files = FileManager.default.subpaths(atPath: tmpPath)
        
        for file in files! {
            let path = tmpPath.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                try! FileManager.default.removeItem(atPath: path)
            }
        }
    }
    
    private func formatFileSize(bytes: Float) -> String {
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


