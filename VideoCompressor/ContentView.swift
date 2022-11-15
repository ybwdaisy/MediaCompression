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
                ProgressView(String(format: "%.0f %%", min(progress, 1.0) * 100.0), value: progress, total: 1.0)
                    .padding()
                Spacer()
                ZStack {
                    Circle()
                        .stroke(lineWidth: 5.0)
                        .opacity(0.3)
                        .foregroundColor(Color.orange)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.orange)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: progress)

                    VStack{
                        Text(String(format: "%.0f %%", min(progress, 1.0) * 100.0))
                    }
                }
                    .padding(60.0)
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
