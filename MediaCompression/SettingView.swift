//
//  SettingView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/21.
//

import SwiftUI

struct SettingView: View {
    @State var imageCompressionQuality: Float = 0.5
    @State var imageCreationDate: Bool = true
    
    @State var videoCompressionQuality: String = "高"
    @State var videoCreationDate: Bool = true
    
    @State var audioAutoSave: Bool = false
    @State var audioAllowsMultiple: Bool = true
    
    @State var alertPresented = false
    @State var cacheSize: String = ""
    @State var isSharePresented: Bool = false
    @State var activityItems: [Any] = []
    @State var version: String = ""
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Photos")
                        .foregroundColor(Color(UIColor.systemGray2))
                        .font(.system(size: 16))
                    HStack {
                        Text("Compression Quality")
                            .foregroundColor(Color(UIColor.label))
                        Stepper("\(String(format:"%.1f", imageCompressionQuality))", value: $imageCompressionQuality, in: 0.1...1.0, step: 0.1)
                    }
                    .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                    .background(Color.white)
                    .cornerRadius(10.0)
                    Toggle("Keep Creation Date", isOn: $imageCreationDate)
                        .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                        .background(Color.white)
                        .cornerRadius(10.0)
                }
                .padding(EdgeInsets(top: 0, leading: 20.0, bottom: 20.0, trailing: 20.0))
                VStack(alignment: .leading) {
                    Text("Videos")
                        .foregroundColor(Color(UIColor.systemGray2))
                        .font(.system(size: 16))
                    HStack {
                        Text("Compression Quality")
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        Picker(selection: $videoCompressionQuality) {
                            Text("Low")
                            Text("Medium")
                            Text("Highest")
                        } label: {}
                    }
                    .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                    .background(Color.white)
                    .cornerRadius(10.0)
                    Toggle("Keep Creation Date", isOn: $videoCreationDate)
                        .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                        .background(Color.white)
                        .cornerRadius(10.0)
                }
                .padding(EdgeInsets(top: 0, leading: 20.0, bottom: 20.0, trailing: 20.0))
                VStack(alignment: .leading) {
                    Text("Audios")
                        .foregroundColor(Color(UIColor.systemGray2))
                        .font(.system(size: 16))
                    Toggle("Auto Save to Files App", isOn: $audioAutoSave)
                        .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                        .background(Color.white)
                        .cornerRadius(10.0)
                    Toggle("Allows Multiple Selection", isOn: $audioAllowsMultiple)
                        .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                        .background(Color.white)
                        .cornerRadius(10.0)
                }
                .padding(EdgeInsets(top: 0, leading: 20.0, bottom: 20.0, trailing: 20.0))
                VStack(alignment: .leading) {
                    Text("Others")
                        .foregroundColor(Color(UIColor.systemGray2))
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
                        alertPresented = true
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
                .padding(EdgeInsets(top: 0, leading: 20.0, bottom: 20.0, trailing: 20.0))
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .alert(isPresented: $alertPresented) {
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
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
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


