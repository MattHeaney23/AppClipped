//
//  AppClipCodeGenerator.swift
//  AppClipped
//
//  Created by Matt Heaney on 02/03/2025.
//

import Cocoa

class AppClipCodeGenerator {

    let appClipSaver = AppClipSaver()
    let appClipToolLocator = AppClipToolLocator()
    let commandExecuter = CommandExecuter()

    func generateAppClipCode(url: String,
                             selectedColorMode: SelectedColorMode,
                             selectedMode: SelectedMode,
                             logoStyle: LogoStyle) async throws {

        guard let outputURL = await appClipSaver.promptUserForSaveLocation() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User canceled save dialog"])
        }

        guard let toolPath = appClipToolLocator.validateToolInstallation() else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "AppClipCodeGenerator not found. Please install it."])
        }

        try await commandExecuter.executeCommand(toolPath: toolPath,
                                                 url: url,
                                                 selectedColorMode: selectedColorMode,
                                                 selectedMode: selectedMode,
                                                 logoStyle: logoStyle,
                                                 outputURL: outputURL)
    }
}
