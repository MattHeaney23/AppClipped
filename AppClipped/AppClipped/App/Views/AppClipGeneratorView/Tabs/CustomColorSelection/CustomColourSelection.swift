//
//  CustomColourSelection.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//

import SwiftUI

struct CustomColourSelection: View {

    //MARK: Dependancies
    @State var viewModel: CustomColourSelectionViewModel

    //MARK: Body
    var body: some View {
        HStack(spacing: 40) {
            VStack(spacing: 12) {
                HStack {

                    Text("Background Colour")
                        .frame(width: 150, alignment: .leading)
                        .bold()
                    ColorPicker("", selection: $viewModel.customBackgroundColor, supportsOpacity: false)
                        .labelsHidden()
                }

                HStack {
                    Text("Foreground Colour")
                        .frame(width: 150, alignment: .leading)
                        .bold()
                    ColorPicker("", selection: $viewModel.customForegroundColor, supportsOpacity: false)
                        .labelsHidden()
                }
            }

            AppClipColorPreview(customForegroundColor: $viewModel.customForegroundColor,
                                customBackgroundColor: $viewModel.customBackgroundColor)
                .frame(width: 150, height: 150)
        }
        .frame(height: 120)
        .padding(.vertical, 20)
    }

}
