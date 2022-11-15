//
//  ContentView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI

struct ContentView: View {
    @State var pickerType: NSNumber = 1
    @State var image: Image?
    @State var isPresented: Bool = false
    @State var selectedImages: [UIImage] = []
    @State var progressList: [Float] = []
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button() {
                        pickerType = 1
                        selectedImages = [];
                        isPresented = true
                    } label: {
                        Label("Select Photo", systemImage: "photo")
                    }
                    Button {
                        pickerType = 2
                        selectedImages = [];
                        isPresented = true
                        progressList = []
                    } label: {
                        Label("Select Video", systemImage: "photo.on.rectangle.angled")
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
                image?
                    .resizable()
                    .scaledToFit()
                    .padding()
                Spacer()
            }
            .padding(EdgeInsets(top: CGFloat(20.0), leading: 0, bottom: 0, trailing: 0))
            .navigationTitle("Video Compressor")
            .navigationBarItems(
                trailing:
                    NavigationLink {
                        
                    } label: {
                        Image(systemName: "gear")
                    }
            )
            .sheet(isPresented: $isPresented, onDismiss: loadImage) {
                SheetView(pickerType: $pickerType, images: $selectedImages, progressList: $progressList)
            }
        }
    }
    func loadImage() {
        if (selectedImages.count > 0) {
            image = Image(uiImage: selectedImages[0])
        }
        
    }
}

struct SheetView: View {
    @Binding var pickerType: NSNumber
    @Binding var images: [UIImage]
    @Binding var progressList: [Float]
    
    var body: some View {
        if (pickerType == 1) {
            ImagePickerView(images: $images);
        }
        if (pickerType == 2) {
            PHImagePickerView(images: $images, progressList: $progressList);
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
