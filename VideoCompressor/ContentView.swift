//
//  ContentView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI

struct ContentView: View {
    @State var pickerType: NSNumber = 1
    @State var isPresented: Bool = false
    @State var progressList: [Float] = []
    @State var compressFinished: Bool = false
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
                            pickerType = 1
                            isPresented = true
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
                            isPresented = true
                            progressList = []
                        }
                        HStack {
                            Image(systemName: "doc")
                                .foregroundColor(Color(UIColor.systemBlue))
                                .frame(width: 25.0)
                            Text("Documents")
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
                            isPresented = true
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
            .navigationTitle("Video Compressor")
            .navigationBarItems(
                trailing:
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gear")
                    }
            )
            .sheet(isPresented: $isPresented, onDismiss: nil) {
                SheetView(pickerType: $pickerType, progressList: $progressList, compressFinished: $compressFinished)
            }
            .alert(isPresented: $compressFinished) {
                Alert(title: Text("The compressed image has been saved to the album."))
            }
        }
    }
}

struct SheetView: View {
    @Binding var pickerType: NSNumber
    @Binding var progressList: [Float]
    @Binding var compressFinished: Bool
    
    var body: some View {
        if (pickerType == 1) {
            ImagePickerView(progressList: $progressList, compressFinished: $compressFinished);
        }
        if (pickerType == 2) {
            PHImagePickerView(progressList: $progressList);
        }
        if (pickerType == 3) {
            DocumentPickerView(progressList: $progressList);
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
