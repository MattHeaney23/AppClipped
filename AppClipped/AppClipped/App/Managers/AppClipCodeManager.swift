//
//  AppClipCodeManager.swift
//  AppClipped
//
//  Created by Matt Heaney on 02/03/2025.
//

import Cocoa

///A class that will handle the process of generating and saving a new App Clip code
class AppClipCodeManager {

    let appClipSaveManager = AppClipSaveManager()
    let appClipToolManager = AppClipToolManager()
    let appClipCommandManager = AppClipCommandManager()

    func generateAppClipCode(url: String,
                             selectedColorMode: SelectedColorMode,
                             selectedMode: SelectedMode,
                             logoStyle: LogoStyle) async throws {

        guard let outputURL = await appClipSaveManager.promptUserForSaveLocation() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User canceled save dialog"])
        }

        guard let toolPath = appClipToolManager.validateToolInstallation() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "AppClipCodeGenerator not found. Please install it."])
        }

        try await appClipCommandManager.executeCommand(toolPath: toolPath,
                                                       url: url,
                                                       selectedColorMode: selectedColorMode,
                                                       selectedMode: selectedMode,
                                                       logoStyle: logoStyle,
                                                       outputURL: outputURL)
    }
}
