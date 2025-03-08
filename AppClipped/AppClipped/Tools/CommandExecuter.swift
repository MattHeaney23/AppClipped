//
//  CommandExecuter.swift
//  AppClipped
//
//  Created by Matt Heaney on 08/03/2025.
//

import Cocoa

class CommandExecuter {

    private func buildCommandString(toolPath: String,
                                    url: String,
                                    index: Int?,
                                    backgroundColour: String?,
                                    foregroundColour: String?,
                                    selectedMode: SelectedMode,
                                    logoStyle: LogoStyle,
                                    outputURL: URL) -> String? {
        if let index = index {
            return "\"\(toolPath)\" generate --url \"\(url)\" --type \(selectedMode.rawValue) --logo \(logoStyle.showLogoParameter) --index \(index) --output \"\(outputURL.path)\""
        } else if let foregroundColour = foregroundColour, let backgroundColour = backgroundColour {
            return "\"\(toolPath)\" generate --url \"\(url)\" --type \(selectedMode.rawValue) --logo \(logoStyle.showLogoParameter) --foreground \(foregroundColour) --background \(backgroundColour) --output \"\(outputURL.path)\""
        }
        return nil
    }

    public func executeCommand(toolPath: String,
                                url: String,
                                index: Int?,
                                backgroundColour: String?,
                                foregroundColour: String?,
                                selectedMode: SelectedMode,
                                logoStyle: LogoStyle,
                               outputURL: URL) async throws {


        guard let commandString = buildCommandString(toolPath: toolPath,
                                                     url: url,
                                                     index: index,
                                                     backgroundColour: backgroundColour,
                                                     foregroundColour: foregroundColour,
                                                     selectedMode: selectedMode,
                                                     logoStyle: logoStyle,
                                                     outputURL: outputURL) else {
            throw NSError.init() //
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", commandString]

        let pipe = Pipe()
        process.standardOutput = pipe
        let errorPipe = Pipe()
        process.standardError = errorPipe

        print("Running command: \(commandString)")

        try process.run()
        process.waitUntilExit()

        let terminationStatus = process.terminationStatus
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let errorMessage = String(data: errorData, encoding: .utf8) ?? "No error"

        print("Status: \(terminationStatus)")
        print("Error: \(errorMessage)")

        if terminationStatus != 0 || !errorMessage.isEmpty {
            throw NSError(domain: "", code: Int(terminationStatus), userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
}
