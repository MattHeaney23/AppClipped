//
//  AppClipColorPreview.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//

import SwiftUI

struct AppClipColorPreview: View {

    @Binding var customForegroundColor: Color
    @Binding var customBackgroundColor: Color

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(customBackgroundColor)
                .cornerRadius(24)
            Image(.appClipLinesLayer1)
                .resizable()
                 .renderingMode(.template)
                 .foregroundColor(customForegroundColor)
                 .padding(5)
            Image(.appClipLinesLayer2)
                .resizable()
                 .renderingMode(.template)
                 .foregroundColor(customForegroundColor.opacity(0.6))
                 .padding(5)
        }
    }

}
