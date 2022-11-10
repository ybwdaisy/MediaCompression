//
//  ContentView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePickerView = false
    @State private var inputImage: UIImage?
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                if image != nil {
                   image?
                       .resizable()
                       .scaledToFit()
                } else {
                    Button("选择照片") {
                        self.showingImagePickerView = true
                    }
                }
            }
            .navigationTitle("导航")
            .navigationBarItems(
                trailing:
                    NavigationLink {
                        
                    } label: {
                        Image(systemName: "gear")
                    }
            )
            .sheet(isPresented: $showingImagePickerView, onDismiss: loadImage) {
                ImagePickerView(image: self.$inputImage)
            }
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
