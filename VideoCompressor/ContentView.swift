//
//  ContentView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI

struct ContentView: View {
    @State var image: Image?
    @State var isPresented: Bool = false
    @State var pickerType: NSNumber = 0
    @State var selectedImage: UIImage?
    @State var selectedImages: [UIImage] = []
    var body: some View {
        NavigationView {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()

                Button("打开相册1") {
                    self.isPresented = true
                    self.pickerType = 0
                    self.selectedImages = [];
                }
                Button("打开相册2") {
                    self.isPresented = true
                    self.pickerType = 1
                    self.selectedImage = nil;
                }
            }
            
            .navigationTitle("相册")
            .navigationBarItems(
                trailing:
                    NavigationLink {
                        
                    } label: {
                        Image(systemName: "gear")
                    }
            )
            .sheet(isPresented: $isPresented, onDismiss: loadImage) {
                if (pickerType == 0) {
                    ImagePickerView(image: $selectedImage)
                } else {
                    PHImagePickerView(images: $selectedImages)
                }
            }
        }
    }
    func loadImage() {
        if selectedImage != nil {
            image = Image(uiImage: selectedImage!)
        }
        if (selectedImages.count > 0) {
            image = Image(uiImage: selectedImages[0])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
