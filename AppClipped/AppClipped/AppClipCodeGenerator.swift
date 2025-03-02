//
//  AppClipCodeGenerator.swift
//  AppClipped
//
//  Created by Matt Heaney on 02/03/2025.
//

import Cocoa

class AppClipCodeGenerator {
    func generateAppClipCode(url: String, index: Int, selectedMode: SelectedMode, logoStyle: LogoStyle, completion: @escaping (Result<String, Error>) -> Void) {
        // Set up the save panel
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "AppClip" // Default filename
        savePanel.allowedContentTypes = [.svg] // Restrict to SVG files
        savePanel.canCreateDirectories = true // Allow folder creation
        savePanel.directoryURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Desktop") // Default to Desktop

        // Show the save panel
        guard savePanel.runModal() == .OK, let outputURL = savePanel.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User canceled save dialog"])))
            return
        }

        // Command string using the user-selected path
        let commandString = "/Library/Developer/AppClipCodeGenerator/AppClipCodeGenerator.bundle/Contents/MacOS/AppClipCodeGenerator generate --url \"\(url)\" --type \(selectedMode.rawValue) --logo \(logoStyle.showLogoParameter) --index \(index) --output \"\(outputURL.path)\""

        // Use /bin/zsh to interpret the command
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", commandString]

        // Set up pipes
        let pipe = Pipe()
        process.standardOutput = pipe
        let errorPipe = Pipe()
        process.standardError = errorPipe

        // Log the command
        print("Running command: \(commandString)")

        // Run the process
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
