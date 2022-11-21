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
            VStack {
                HStack {
                    Spacer()
                    Button() {
                        pickerType = 1
                        isPresented = true
                    } label: {
                        Label("Photo", systemImage: "photo")
                    }
                    Button {
                        pickerType = 2
                        isPresented = true
                        progressList = []
                    } label: {
                        Label("Video", systemImage: "photo.on.rectangle.angled")
                    }
                    Button {
                        pickerType = 3
                        isPresented = true
                        progressList = []
                    } label: {
                        Label("Document", systemImage: "arrow.triangle.2.circlepath.doc.on.clipboard")
                    }
                    Spacer()
                }
                Spacer()
                List(progressList, id: \.description) { progress in
                    VStack {
                        ProgressView(String(format: "%.0f %%", min(progress, 1.0) * 100.0), value: progress, total: 1.0)
                            .padding()
                    }
                }
                Spacer()
            }
            .padding(EdgeInsets(top: CGFloat(20.0), leading: 0, bottom: 0, trailing: 0))
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
