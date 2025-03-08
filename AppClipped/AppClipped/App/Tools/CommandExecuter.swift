//
//  CommandExecuter.swift
//  AppClipped
//
//  Created by Matt Heaney on 08/03/2025.
//

import Cocoa

class CommandExecuter {

    public func executeCommand(toolPath: String,
                               url: String,
                               selectedColorMode: SelectedColorMode,
                               selectedMode: SelectedMode,
                               logoStyle: LogoStyle,
                               outputURL: URL) async throws {


        let commandString = buildCommandString(toolPath: toolPath,
                                               url: url,
                                               selectedColorMode: selectedColorMode,
                                               selectedMode: selectedMode,
                                               logoStyle: logoStyle,
                                               outputURL: outputURL)

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

    private func buildCommandString(toolPath: String,
                                    url: String,
                                    selectedColorMode: SelectedColorMode,
                                    selectedMode: SelectedMode,
                                    logoStyle: LogoStyle,
                                    outputURL: URL) -> String {

        var arguments: [String] = [
            "\"\(toolPath)\"",
            "generate",
            "--url \"\(url)\"",
            "--type \(selectedMode.rawValue)",
            "--logo \(logoStyle.showLogoParameter)",
            "--output \"\(outputURL.path)\""
        ]

        switch selectedColorMode {
        case .index(let indexID):
            arguments.append("--index \(indexID)")
        case .custom(let foregroundColour, let backgroundColor):
            arguments.append("--foreground \(foregroundColour.toHex() ?? "")")
            arguments.append("--background \(backgroundColor.toHex() ?? "")")
        }

        return arguments.joined(separator: " ")
    }
}
