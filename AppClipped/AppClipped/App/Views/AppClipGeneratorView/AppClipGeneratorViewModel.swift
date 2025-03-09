//
//  AppClipGeneratorViewModel.swift
//  AppClipped
//
//  Created by Matt Heaney on 09/03/2025.
//

import SwiftUI

class AppClipGeneratorViewModel: ObservableObject {

    //MARK: Dependancies
    let appClipToolManager = AppClipToolManager()
    let appClipCodeManager = AppClipCodeManager()

    //MARK: User Entered Values
    @Published var enteredURL: String = ""

    @Published var selectedColorModeTab: Int = 0
    @Published var selectedColorIndexItem: Int = 0

    @Published var customBackgroundColor: Color = .blue
    @Published var customForegroundColor: Color = .white

    @Published var selectedMode: ModeType = .camera
    @Published var logoStyle: LogoType = .logoIncluded

    //MARK: State
    @Published var state: AppClipGeneratorState = .ready

    //MARK: Additional UI Values
    @Published var shouldShowInstallationMessage: Bool = false

    var selectedColorMode: ColorType {
        if selectedColorModeTab == 0 {
            return .index(indexID: selectedColorIndexItem)
        } else {
            return .custom(foregroundColour: customBackgroundColor,
                           backgroundColor: customForegroundColor)
        }
    }

    init() {
        self.shouldShowInstallationMessage = !appClipToolManager.isToolInstaller()
    }

    func generateAppClipCode() async {

        await MainActor.run { state = .loading }

        do {
            try await appClipCodeManager.generateAppClipCode(
                url: enteredURL,
                selectedColorMode: selectedColorMode,
                selectedMode: selectedMode,
                logoStyle: logoStyle
            )

            await MainActor.run { state = .ready }

        } catch(let error) {
            await MainActor.run { state = .error(error) }
        }
    }
}
