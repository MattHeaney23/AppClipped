//
//  AppClipCodeGenerator.swift
//  AppClipped
//
//  Created by Matt Heaney on 02/03/2025.
//

import Cocoa

class AppClipCodeGenerator {
    func generateAppClipCode(url: String,
                             index: Int?,
                             backgroundColour: String?,
                             foregroundColour: String?,
                             selectedMode: SelectedMode,
                             logoStyle: LogoStyle,
                             completion: @escaping (Result<String, Error>) -> Void) {
        // Set up the save panel
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "AppClip"
        savePanel.allowedContentTypes = [.svg]
        savePanel.canCreateDirectories = true
        savePanel.directoryURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Desktop")

        guard savePanel.runModal() == .OK, let outputURL = savePanel.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User canceled save dialog"])))
            return
        }

        // Define the tool path
        let toolPath = "/usr/local/bin/AppClipCodeGenerator"

        // Check if the tool exists
        guard FileManager.default.fileExists(atPath: toolPath) else {
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "AppClipCodeGenerator Not Found"
                alert.informativeText = "This app requires AppClipCodeGenerator installed at /usr/local/bin/. Please download and install it from [source URL] or contact support for instructions."
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "AppClipCodeGenerator not found at /usr/local/bin/. Please install it."])))
            return
        }

        // Build the command string
        var commandString: String
        if let index = index {
            commandString = "\"\(toolPath)\" generate --url \"\(url)\" --type \(selectedMode.rawValue) --logo \(logoStyle.showLogoParameter) --index \(index) --output \"\(outputURL.path)\""
        } else if let foregroundColour = foregroundColour, let backgroundColour = backgroundColour {
            commandString = "\"\(toolPath)\" generate --url \"\(url)\" --type \(selectedMode.rawValue) --logo \(logoStyle.showLogoParameter) --foreground \(foregroundColour) --background \(backgroundColour) --output \"\(outputURL.path)\""
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters: provide either index or both foreground and background colors"])))
            return
        }

        // Run the command with /bin/sh
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", commandString]

        let pipe = Pipe()
        process.standardOutput = pipe
        let errorPipe = Pipe()
        process.standardError = errorPipe

        print("Running command: \(commandString)")

        do {
            try process.run()
            process.waitUntilExit()

            let terminationStatus = process.terminationStatus
            let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outputData, encoding: .utf8) ?? "No output"
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let errorMessage = String(data: errorData, encoding: .utf8) ?? "No error"

            print("Status: \(terminationStatus)")
            print("Output: \(output)")
            print("Error: \(errorMessage)")

            if terminationStatus == 0 && errorMessage.isEmpty {
                completion(.success("App Clip Code generated at \(outputURL.path)"))
            } else {
                completion(.failure(NSError(domain: "", code: Int(terminationStatus), userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        } catch {
            print("Failed to run process: \(error)")
            completion(.failure(error))
        }
    }
}
