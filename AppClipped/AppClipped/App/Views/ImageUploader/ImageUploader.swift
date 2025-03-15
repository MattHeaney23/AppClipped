//
//  ImageUploader.swift
//  AppClipped
//
//  Created by Matt Heaney on 12/03/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImageUploader: View {

    //MARK: Dependencies

    let imageToColorManager = ImageToColorManager()

    @Binding var foregroundColor: Color
    @Binding var backgroundColor: Color

    @Binding var image: NSImage?

    //MARK: Body

    var body: some View {
        VStack {
            if let image = image {
                VStack {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            } else {
                Text("Drag an image here to create your App Clip Code style")
                    .multilineTextAlignment(.center)
                    .frame(width: 150, height: 150)
                    .border(Color.gray, width: 2)
            }
        }
        .onDrop(of: [UTType.image.identifier], isTargeted: nil) { providers in

            Task {
                if let provider = providers.first {
                    do {
                        let data = try await loadImageData(from: provider)
                        if let nsImage = NSImage(data: data) {
                            self.image = nsImage
                            let colors = imageToColorManager.processImage(nsImage)
                            self.backgroundColor = colors[0]
                            self.foregroundColor = colors[1]
                        }
                    } catch {
                        print("Error loading image data: \(error)")
                    }
                }
            }
            return true
        }
    }

    //MARK: Helpers
    private func loadImageData(from provider: NSItemProvider) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NSError(domain: "LoadDataError", code: -1, userInfo: nil))
                }
            }
        }
    }
}
