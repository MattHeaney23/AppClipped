//
//  AppClipGeneratorViewModel.swift
//  AppClipped
//
//  Created by Matt Heaney on 09/03/2025.
//

import SwiftUI

class AppClipGeneratorViewModel: ObservableObject {

    let appClipToolManager = AppClipToolManager()
    let appClipCodeManager = AppClipCodeManager()

    @State var enteredURL: String = ""

    @State var selectedColorModeTab: Int = 0
    @State var selectedColorIndexItem: Int = 0
    @State var customBackgroundColor: Color = .blue
    @State var customForegroundColor: Color = .white

    @State var selectedMode: SelectedMode = .camera
    @State var logoStyle: LogoStyle = .includeAppClipLogo

    @State var errorMessage: String?

    let labelWidth: CGFloat = 100

    @Published var shouldShowInstallationMessage: Bool = false

    init() {
        self.shouldShowInstallationMessage = !appClipToolManager.isToolInstaller()
    }

    func generateAppClipCode() async {

        var selectedColorMode: SelectedColorMode {
            if selectedColorModeTab == 0 {
                return .index(indexID: selectedColorIndexItem)
            } else {
                return .custom(foregroundColour: customBackgroundColor,
                               backgroundColor: customForegroundColor)
            }
        }

        do {
            try await appClipCodeManager.generateAppClipCode(
                url: enteredURL,
                selectedColorMode: selectedColorMode,
                selectedMode: selectedMode,
                logoStyle: logoStyle
            )
        } catch(let error) {
            self.errorMessage = error.localizedDescription
        }
    }
}
