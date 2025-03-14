//
//  LogoBasedColorSelection.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//
//

import SwiftUI

struct LogoBasedColorSelection: View {

    @State var viewModel:  LogoBasedColorSelectionViewModel

    var body: some View {
        HStack(spacing: 40) {
            ImageUploader(foregroundColor: $viewModel.customForegroundColor,
                          backgroundColor: $viewModel.customBackgroundColor,
                          image: $viewModel.uploadedImage)

            AppClipColorPreview(customForegroundColor: $viewModel.customForegroundColor,
                                customBackgroundColor: $viewModel.customBackgroundColor)
            .frame(width: 150, height: 150)
        }
    }

}
