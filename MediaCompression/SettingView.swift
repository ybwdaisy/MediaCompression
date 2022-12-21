//
//  SettingView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/21.
//

import SwiftUI
import CoreData

enum VideoCompressionQuality {
    case AVAssetExportPresetLowQuality, AVAssetExportPresetMediumQuality, AVAssetExportPresetHighestQuality
}

struct SettingView: View {
    @State var imageCompressionQuality: Float = 0.5
    @State var imageKeepCreationDate: Bool = false
    
    @State var videoCompressionQuality: VideoCompressionQuality = .AVAssetExportPresetHighestQuality
    @State var videoKeepCreationDate: Bool = false
    @State var videoSelectionLimit: Int = 10;
    
    @State var audioAutoSave: Bool = false
    @State var audioAllowsMultiple: Bool = false
    
    @State var alertPresented = false
    @State var cacheSize: String = ""
    @State var isSharePresented: Bool = false
    @State var activityItems: [Any] = []
    @State var version: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Settings.objectID, ascending: true)],
      animation: .default)

    private var settings: FetchedResults<Settings>
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Photos")
                        .foregroundColor(Color(UIColor.systemGray2))
                        .font(.system(size: 16))
                    HStack {
                        Text("Quality")
                            .foregroundColor(Color(UIColor.label))
                        Stepper(value: $imageCompressionQuality, in: 0.1...1.0, step: 0.1) {
                            Text("\(String(format:"%.1f", imageCompressionQuality))")
                        }
                    }
                    .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                    .background(Color.white)
                    .cornerRadius(10.0)
                    Toggle("Keep Creation Date", isOn: $imageKeepCreationDate)
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
                        Text("Quality")
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        Picker(selection: $videoCompressionQuality) {
                            Text("Low").tag(VideoCompressionQuality.AVAssetExportPresetLowQuality)
                            Text("Medium").tag(VideoCompressionQuality.AVAssetExportPresetMediumQuality)
                            Text("Highest").tag(VideoCompressionQuality.AVAssetExportPresetHighestQuality)
                        } label: {}
                    }
                    .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                    .background(Color.white)
                    .cornerRadius(10.0)
                    HStack {
                        Text("Selection Limit")
                            .foregroundColor(Color(UIColor.label))
                        Stepper(value: $videoSelectionLimit, in: 1...99, step: 1) {
                            Text("\(videoSelectionLimit)")
                        }
                    }
                    .padding(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
                    .background(Color.white)
                    .cornerRadius(10.0)
                    Toggle("Keep Creation Date", isOn: $videoKeepCreationDate)
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
            if !settings.isEmpty {
                imageCompressionQuality = settings[0].imageCompressionQuality
                imageKeepCreationDate = settings[0].imageKeepCreationDate
                videoCompressionQuality = tranformVideoCompressionQuality(quality: settings[0].videoCompressionQuality)
                videoKeepCreationDate = settings[0].videoKeepCreationDate
                videoSelectionLimit = settings[0].videoSelectionLimit
                audioAutoSave = settings[0].audioAutoSave
                audioAllowsMultiple = settings[0].audioAllowsMultiple
            }
        }
        .onChange(of: imageCompressionQuality) { newValue in            
            syncData()
        }
        .onChange(of: imageKeepCreationDate) { newValue in
            syncData()
        }
        .onChange(of: videoCompressionQuality) { newValue in
            syncData()
        }
        .onChange(of: videoKeepCreationDate) { newValue in
            syncData()
        }
        .onChange(of: videoSelectionLimit) { newValue in
            syncData()
        }
        .onChange(of: audioAutoSave) { newValue in
            syncData()
        }
        .onChange(of: audioAllowsMultiple) { newValue in
            syncData()
        }
    }
    
    private func submitClearCache() {
        clearCache()
        cacheSize = calculateCache()
    }
    
    private func syncData () {
        do {
            if !settings.isEmpty {
                settings[0].imageCompressionQuality = imageCompressionQuality
                settings[0].imageKeepCreationDate = imageKeepCreationDate
                settings[0].videoCompressionQuality = "\(videoCompressionQuality)"
                settings[0].videoKeepCreationDate = videoKeepCreationDate
                settings[0].videoSelectionLimit = videoSelectionLimit
                settings[0].audioAutoSave = audioAutoSave
                settings[0].audioAllowsMultiple = audioAllowsMultiple
            } else {
                let settingsModel = Settings(context: viewContext)
                settingsModel.imageCompressionQuality = imageCompressionQuality
                settingsModel.imageKeepCreationDate = imageKeepCreationDate
                settingsModel.videoCompressionQuality = "\(videoCompressionQuality)"
                settingsModel.videoKeepCreationDate = videoKeepCreationDate
                settingsModel.videoSelectionLimit = videoSelectionLimit
                settingsModel.audioAutoSave = audioAutoSave
                settingsModel.audioAllowsMultiple = audioAllowsMultiple
            }
            try viewContext.save()
        } catch {
            print("error")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


