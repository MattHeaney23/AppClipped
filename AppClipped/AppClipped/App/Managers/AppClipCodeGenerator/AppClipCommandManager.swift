//
//  AppClipCommandManager.swift
//  AppClipped
//
//  Created by Matt Heaney on 08/03/2025.
//

import Cocoa

///Handles creating and executing the command to generate the App Clip code
class AppClipCommandManager {

    ///Executes the command to generate the App Clip Code, and stores it in the provided location
    public func executeCommand(toolPath: String,
                               url: String,
                               selectedColorMode: ColorType,
                               selectedMode: ModeType,
                               logoStyle: LogoType,
                               outputURL: URL) async throws {

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

        let commandString = arguments.joined(separator: " ")

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", commandString]

        let pipe = Pipe()
        process.standardOutput = pipe
        let errorPipe = Pipe()
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        let terminationStatus = process.terminationStatus
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let errorMessage = String(data: errorData, encoding: .utf8) ?? "No error"

        if terminationStatus != 0 || !errorMessage.isEmpty {
            throw NSError(domain: "", code: Int(terminationStatus), userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
}
