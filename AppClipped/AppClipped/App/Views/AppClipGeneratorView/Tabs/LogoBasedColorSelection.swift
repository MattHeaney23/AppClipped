//
//  LogoBasedColorSelection.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//
//

import SwiftUI

struct LogoBasedColorSelection: View {

    @Binding var customForegroundColor: Color
    @Binding var customBackgroundColor: Color

    var body: some View {
        HStack(spacing: 40) {
            ImageUploader(foregroundColor: $customForegroundColor,
                          backgroundColor: $customBackgroundColor)

            AppClipColorPreview(customForegroundColor: $customForegroundColor,
                                customBackgroundColor: $customBackgroundColor)
            .frame(width: 150, height: 150)
        }
    }

}
