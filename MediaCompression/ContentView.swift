//
//  ContentView.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI

struct ContentView: View {
    @State var pickerType: NSNumber = 1
    @State var isMediaPresented: Bool = false
    @State var progressList: [Float] = []
    @State var compressFinished: Bool = false
    @State var isSharePresented: Bool = false
    @State var activityItems: [Any] = []
    @State var isActionSheetPresented: Bool = false
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
                            isActionSheetPresented = true
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
                            pickerType = 2
                            isMediaPresented = true
                            progressList = []
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
                            pickerType = 3
                            isMediaPresented = true
                            progressList = []
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
                        Image(systemName: "gear")
                    }
            )
            .sheet(isPresented: $isMediaPresented, onDismiss: nil) {
                MediaView(
                    pickerType: $pickerType,
                    progressList: $progressList,
                    compressFinished: $compressFinished,
                    isSharePresented: $isSharePresented,
                    activityItems: $activityItems,
                    imagePickerType: $imagePickerType
                )
            }
            .sheet(isPresented: $isSharePresented, onDismiss: nil) {
                ActivityViewController(activityItems: $activityItems)
            }
            .alert(isPresented: $compressFinished) {
                Alert(title: Text("The compressed image has been saved to the album."))
            }
            .actionSheet(isPresented: $isActionSheetPresented) {
                ActionSheet(
                    title: Text("Select photos or take photos"),
                    buttons: [
                        .default(Text("Select photos"), action: {
                            cameraUsagePermissions(authorizedBlock: {
                                imagePickerType = 1
                                isMediaPresented = true
                                pickerType = 1
                                progressList = []
                            }, deniedBlock: {
                                
                            })
                        }),
                        .default(Text("Take photos"), action: {
                            cameraUsagePermissions(authorizedBlock: {
                                imagePickerType = 2
                                pickerType = 1
                                isMediaPresented = true
                            }, deniedBlock: {
                                
                            })
                        }),
                        .cancel(Text("Cancel"))
                    ]
                );
            }
        }
    }
}

struct MediaView: View {
    @Binding var pickerType: NSNumber
    @Binding var progressList: [Float]
    @Binding var compressFinished: Bool
    @Binding var isSharePresented: Bool
    @Binding var activityItems: [Any]
    @Binding var imagePickerType: NSNumber
    
    var body: some View {
        if (pickerType == 1) {
            ImagePickerView(
                progressList: $progressList,
                compressFinished: $compressFinished,
                imagePickerType: $imagePickerType
            )
        }
        if (pickerType == 2) {
            PHImagePickerView(
                progressList: $progressList
            )
        }
        if (pickerType == 3) {
            DocumentPickerView(
                progressList: $progressList,
                isSharePresented: $isSharePresented,
                activityItems: $activityItems
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
