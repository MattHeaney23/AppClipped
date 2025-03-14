//
//  ImageUploader.swift
//  AppClipped
//
//  Created by Matt Heaney on 12/03/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImageUploader: View {

    let imageToColorManager = ImageToColorManager()

    @Binding var foregroundColor: Color
    @Binding var backgroundColor: Color

    @Binding var image: NSImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            } else {
                Text("Drag an image here")
                    .frame(width: 150, height: 150)
                    .border(Color.gray, width: 2)
            }
        }
        .onDrop(of: [UTType.image.identifier], isTargeted: nil) { providers in
            if let provider = providers.first {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    if let data = data, let nsImage = NSImage(data: data) {
                        DispatchQueue.main.async {
                            self.image = nsImage
                            let colors = imageToColorManager.processImage(nsImage)
                            self.backgroundColor = colors[0]
                            self.foregroundColor = colors[1]
                        }
                    }
                }
            }
            return true
        }
    }
}
