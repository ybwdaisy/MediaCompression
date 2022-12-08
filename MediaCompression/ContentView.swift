//
//  ContentView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI

struct ContentView: View {
    @State var isImagePickerActionSheetPresented: Bool = false
    @State var isImagePickerPresented: Bool = false
    @State var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State var isVideoPickerPresented: Bool = false
    
    @State var isDocumentPickerPresented: Bool = false
    @State var isDocumentSharePresented: Bool = false
    @State var documentActivityItems: [Any] = []

    @State var progressList: [Float] = []
    @State var compressFinished: Bool = false
    
    @State var imagePickerType: NSNumber = 1
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
                            cameraUsagePermissions(authorizedBlock: {
                                imagePickerSourceType = .photoLibrary
                                isImagePickerPresented = true
                            }, deniedBlock: {
                                
                            })
                        }),
                        .default(Text("Take photos"), action: {
                            cameraUsagePermissions(authorizedBlock: {
                                imagePickerSourceType = .camera
                                isImagePickerPresented = true
                            }, deniedBlock: {
                                
                            })
                        }),
                        .cancel(Text("Cancel"))
                    ]
                );
            }
            .sheet(isPresented: $isImagePickerPresented, onDismiss: nil) {
                ImagePickerView(
                    compressFinished: $compressFinished,
                    sourceType: $imagePickerSourceType
                )
            }
            .sheet(isPresented: $isVideoPickerPresented, onDismiss: nil) {
                PHImagePickerView(
                    progressList: $progressList,
                    compressFinished: $compressFinished
                )
            }
            .sheet(isPresented: $isDocumentPickerPresented, onDismiss: nil) {
                DocumentPickerView(
                    progressList: $progressList,
                    isSharePresented: $isDocumentSharePresented,
                    activityItems: $documentActivityItems
                )
            }
            .sheet(isPresented: $isDocumentSharePresented, onDismiss: nil) {
                ActivityViewController(activityItems: $documentActivityItems)
            }
            .alert(isPresented: $compressFinished) {
                Alert(title: Text("All items have been compressed."))
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
