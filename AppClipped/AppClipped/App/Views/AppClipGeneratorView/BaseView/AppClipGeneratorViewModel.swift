//
//  AppClipGeneratorViewModel.swift
//  AppClipped
//
//  Created by Matt Heaney on 09/03/2025.
//

import SwiftUI

@MainActor
@Observable
class AppClipGeneratorViewModel {

    //MARK: Dependancies
    let appClipToolManager = AppClipToolManager()
    let appClipCodeManager = AppClipCodeManager()

    var setColourSelectionViewModel = SetColourSelectionViewModel()
    var customColourSelectionViewModel = CustomColourSelectionViewModel()
    var logoBasedColorSelectionViewModel = LogoBasedColorSelectionViewModel()

    //MARK: User Entered Values
    var enteredURL: String = ""

    var selectedColorModeTab: Int = 0
    var selectedColorIndexItem: Int = 0

    var customBackgroundColor: Color = .blue
    var customForegroundColor: Color = .white

    var selectedMode: ModeType = .camera
    var logoStyle: LogoType = .logoIncluded

    //MARK: State
    var state: AppClipGeneratorState = .ready

    //MARK: Additional UI Values
    var shouldShowInstallationMessage: Bool = false

    var selectedColorMode: ColorType {

        switch selectedColorModeTab {
        case 0:
            return .index(indexID: setColourSelectionViewModel.selectedColorIndexItem)
        case 1:
            return .custom(foregroundColour: customColourSelectionViewModel.customForegroundColor,
                           backgroundColor: customColourSelectionViewModel.customBackgroundColor)
        case 2:
            return .custom(foregroundColour: logoBasedColorSelectionViewModel.customForegroundColor,
                           backgroundColor: logoBasedColorSelectionViewModel.customBackgroundColor)
        default:
            return .custom(foregroundColour: Color.black,
                           backgroundColor: Color.white)
        }
    }

    init() {
        self.shouldShowInstallationMessage = !appClipToolManager.isToolInstaller()
    }

    func generateAppClipCode() async {

        state = .loading

        do {
            try await appClipCodeManager.generateAppClipCode(
                url: enteredURL,
                selectedColorMode: selectedColorMode,
                selectedMode: selectedMode,
                logoStyle: logoStyle
            )

            state = .ready

        } catch(let error) {
            state = .error(error)
        }
    }
}
