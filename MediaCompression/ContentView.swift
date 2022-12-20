//
//  ContentView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var isImagePickerActionSheetPresented: Bool = false
    @State var isImagePickerPresented: Bool = false
    @State var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var imageCompressionQuality: Float = 0.5
    @State var imageKeepCreationDate: Bool = false
    
    @State var isVideoPickerPresented: Bool = false
    @State var videoCompressionQuality: String = "\(VideoCompressionQuality.AVAssetExportPresetHighestQuality)"
    @State var videoKeepCreationDate: Bool = false
    
    @State var isDocumentPickerPresented: Bool = false
    @State var isDocumentSharePresented: Bool = false
    @State var documentActivityItems: [Any] = []
    @State var audioAutoSave: Bool = false
    @State var audioAllowsMultiple: Bool = false

    @State var progressList: [Float] = []
    @State var alertPresented: Bool = false
    @State var alertType: NSNumber = 1
    
    @State var imagePickerType: NSNumber = 1
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Settings.imageCompressionQuality, ascending: true)],
      animation: .default)

    private var settings: FetchedResults<Settings>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "photo")
                                .foregroundColor(Color(UIColor.systemBlue))
                                .frame(width: 25.0)
                            Text("Photos")
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10.0)
                        .onTapGesture {
                            progressList = []
                            isImagePickerActionSheetPresented = true
                            alertType = 1
                        }
                        HStack {
                            Image(systemName: "video")
                                .foregroundColor(Color(UIColor.systemBlue))
                                .frame(width: 25.0)
                            Text("Videos")
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10.0)
                        .onTapGesture {
                            progressList = []
                            isVideoPickerPresented = true
                            alertType = 1
                        }
                        HStack {
                            Image(systemName: "waveform")
                                .foregroundColor(Color(UIColor.systemBlue))
                                .frame(width: 25.0)
                            Text("Audios")
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.systemGray2))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10.0)
                        .onTapGesture {
                            progressList = []
                            documentActivityItems = []
                            isDocumentPickerPresented = true
                            alertType = 1
                        }
                    }
                    .padding(EdgeInsets(top: 20.0, leading: 20.0, bottom: 0, trailing: 20.0))
                    List(progressList, id: \.description) { progress in
                        ProgressView(String(format: "%.0f %%", min(progress, 1.0) * 100.0), value: progress, total: 1.0)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Media Compression")
            .navigationBarItems(
                trailing:
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
            )
            .actionSheet(isPresented: $isImagePickerActionSheetPresented) {
                ActionSheet(
                    title: Text("Select photos or take photos"),
                    buttons: [
                        .default(Text("Select photos"), action: {
                            photoLibraryUsagePermissions(authorizedBlock: {
                                imagePickerSourceType = .photoLibrary
                                isImagePickerPresented = true
                            }, deniedBlock: {
                                alertPresented = true
                                alertType = 2
                            })
                        }),
                        .default(Text("Take photos"), action: {
                            cameraUsagePermissions(authorizedBlock: {
                                imagePickerSourceType = .camera
                                isImagePickerPresented = true
                            }, deniedBlock: {
                                alertPresented = true
                                alertType = 2
                            })
                        }),
                        .cancel(Text("Cancel"))
                    ]
                );
            }
            .sheet(isPresented: $isImagePickerPresented, onDismiss: nil) {
                ImagePickerView(
                    compressFinished: $alertPresented,
                    sourceType: $imagePickerSourceType,
                    compressionQuality: $imageCompressionQuality,
                    keepCreationDate: $imageKeepCreationDate
                )
            }
            .sheet(isPresented: $isVideoPickerPresented, onDismiss: nil) {
                PHImagePickerView(
                    progressList: $progressList,
                    compressFinished: $alertPresented,
                    compressionQuality: $videoCompressionQuality,
                    keepCreationDate: $videoKeepCreationDate
                )
            }
            .sheet(isPresented: $isDocumentPickerPresented, onDismiss: nil) {
                DocumentPickerView(
                    progressList: $progressList,
                    isSharePresented: $isDocumentSharePresented,
                    activityItems: $documentActivityItems,
                    compressFinished: $alertPresented,
                    autoSave: $audioAutoSave,
                    allowsMultiple: $audioAllowsMultiple
                )
            }
            .sheet(isPresented: $isDocumentSharePresented, onDismiss: nil) {
                ActivityViewController(activityItems: $documentActivityItems)
            }
            .alert(isPresented: $alertPresented) {
                switch alertType {
                    case 1:
                        return Alert(title: Text("All items have been compressed."))
                    case 2:
                        return Alert(
                            title: Text("Permissions Denied!"),
                            message: Text("Open App Settings to Set Permissions"),
                            primaryButton: .default(Text("OK"), action: openSettings),
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    default:
                        return Alert(title: Text(""))
                }
            }
            .onAppear {
                if !settings.isEmpty {
                    imageCompressionQuality = settings[0].imageCompressionQuality
                    imageKeepCreationDate = settings[0].imageKeepCreationDate
                    
                    videoCompressionQuality = settings[0].videoCompressionQuality
                    videoKeepCreationDate = settings[0].videoKeepCreationDate
                    
                    audioAutoSave = settings[0].audioAutoSave
                    audioAllowsMultiple = settings[0].audioAllowsMultiple
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
