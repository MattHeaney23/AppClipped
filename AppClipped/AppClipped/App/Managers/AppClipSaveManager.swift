//
//  AppClipSaveManager.swift
//  AppClipped
//
//  Created by Matt Heaney on 08/03/2025.
//

import Cocoa

///Handles allowing the user to save the generated App Clip code
class AppClipSaveManager {

    public func promptUserForSaveLocation() async -> URL? {
        return await MainActor.run {
            let savePanel = NSSavePanel()
            savePanel.nameFieldStringValue = "AppClip"
            savePanel.allowedContentTypes = [.svg]
            savePanel.canCreateDirectories = true
            savePanel.directoryURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Desktop")

            return savePanel.runModal() == .OK ? savePanel.url : nil
        }
    }
    
}
