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
    @State var inputImage: UIImage?
    @State var inputImages: [UIImage] = []
    var body: some View {
        NavigationView {
            VStack {
                image?
                    .resizable()
                    .scaledToFit()

                Button("打开相册") {
                    self.isPresented = true
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
//            .sheet(isPresented: $isPresented, onDismiss: loadImage) {
//                ImagePickerView(image: self.$inputImage)
//            }
            .sheet(isPresented: $isPresented, onDismiss: loadImage) {
                PHImagePickerView(isPresented: $isPresented, images: $inputImages)
            }
        }
    }
    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
        if (inputImages.count > 0) {
            image = Image(uiImage: inputImages[0])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
