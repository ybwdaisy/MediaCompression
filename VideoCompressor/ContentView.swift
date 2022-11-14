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
    @State var progress: Float = 0.0
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
                    } label: {
                        Label("Select Video", systemImage: "photo.on.rectangle.angled")
                    }
                    Spacer()
                }
                Spacer()
                ProgressView("", value: progress, total: 1.0)
                    .padding()
                image?
                    .resizable()
                    .scaledToFit()
                    .padding()
                Spacer()
            }
            .padding()
            .navigationTitle("Video Compressor")
            .navigationBarItems(
                trailing:
                    NavigationLink {
                        
                    } label: {
                        Image(systemName: "gear")
                    }
            )
            .sheet(isPresented: $isPresented, onDismiss: loadImage) {
                SheetView(pickerType: $pickerType, images: $selectedImages, progress: $progress)
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
    @Binding var progress: Float
    
    var body: some View {
        if (pickerType == 1) {
            ImagePickerView(images: $images);
        }
        if (pickerType == 2) {
            PHImagePickerView(images: $images, progress: $progress);
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
