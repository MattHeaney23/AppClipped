//
//  AppClipGeneratorViewModel.swift
//  AppClipped
//
//  Created by Matt Heaney on 09/03/2025.
//

import SwiftUI

enum AppClipGeneratorState {
    case ready
    case loading
    case error(Error)
}

class AppClipGeneratorViewModel: ObservableObject {

    let appClipToolManager = AppClipToolManager()
    let appClipCodeManager = AppClipCodeManager()

    @Published var enteredURL: String = ""

    @Published var selectedColorModeTab: Int = 0
    @Published var selectedColorIndexItem: Int = 0
    @Published var customBackgroundColor: Color = .blue
    @Published var customForegroundColor: Color = .white

    @Published var selectedMode: ModeType = .camera
    @Published var logoStyle: LogoType = .logoIncluded

    @Published var state: AppClipGeneratorState = .ready

    @Published var shouldShowInstallationMessage: Bool = false

    let labelWidth: CGFloat = 100

    init() {
        self.shouldShowInstallationMessage = !appClipToolManager.isToolInstaller()
    }

    func generateAppClipCode() async {

        await MainActor.run {
            state = .ready
        }

        var selectedColorMode: ColorType {
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

            await MainActor.run {
                state = .ready
            }

        } catch(let error) {
            await MainActor.run {
                state = .error(error)
            }
        }
    }
}
