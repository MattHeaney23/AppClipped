//
//  AppClipToolManager.swift
//  AppClipped
//
//  Created by Matt Heaney on 08/03/2025.
//

import Cocoa

///Handles locating the AppClipCodeGenerator tool on the user's system
class AppClipToolManager {

    public func validateToolInstallation() -> String? {
        if let toolPath = findToolPath(), FileManager.default.fileExists(atPath: toolPath) {
            return toolPath
        }

        let defaultPath = "/usr/local/bin/AppClipCodeGenerator"
        if FileManager.default.fileExists(atPath: defaultPath) {
            return defaultPath
        }

//Throw this up as an instead

        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "AppClipCodeGenerator Not Found"
            alert.informativeText = "AppClipped requires AppClipCodeGenerator installed. Please download and install it from https://developer.apple.com/download"
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
        return nil
    }

    public func findToolPath() -> String? {
        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = ["AppClipCodeGenerator"]
        process.standardOutput = pipe

        do {
            try process.run()
            process.waitUntilExit()

            let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

            return (output?.isEmpty == false) ? output : nil
        } catch {
            return nil
        }
    }
}
