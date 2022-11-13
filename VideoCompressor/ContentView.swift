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
                        Label("选择单个", systemImage: "photo")
                    }
                    Button {
                        pickerType = 2
                        selectedImages = [];
                        isPresented = true
                    } label: {
                        Label("选择多个", systemImage: "photo.on.rectangle.angled")
                    }
                    Spacer()
                }
                image?
                    .resizable()
                    .scaledToFit()
                    .padding()
                Spacer()
            }
            .padding()
            .navigationTitle("选择相册")
            .navigationBarItems(
                trailing:
                    NavigationLink {
                        
                    } label: {
                        Image(systemName: "gear")
                    }
            )
            .sheet(isPresented: $isPresented, onDismiss: loadImage) {
                SheetView(pickerType: $pickerType, images: $selectedImages)
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
    
    var body: some View {
        if (pickerType == 1) {
            ImagePickerView(images: $images);
        }
        if (pickerType == 2) {
            PHImagePickerView(images: $images);
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
