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
            cacheSize = calculateCache()
            version = getVersion()
        }
    }
    
    private func submitClearCache() {
        clearCache()
        cacheSize = calculateCache()
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}


