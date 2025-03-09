//
//  AppClipToolManager.swift
//  AppClipped
//
//  Created by Matt Heaney on 08/03/2025.
//

import Cocoa

///Handles locating the AppClipCodeGenerator tool on the user's system
class AppClipToolManager {

    ///Returns true to the AppClipCodeGenerator tool is installed and can be found
    public func isToolInstaller() -> Bool {
        return pathForAppClipCodeGenerator() != nil
    }

    ///Returns the path for AppClipCodeGenerator
    public func pathForAppClipCodeGenerator() -> String? {

        let defaultPath = "/usr/local/bin/AppClipCodeGenerator"
        if FileManager.default.fileExists(atPath: defaultPath) {
            return defaultPath
        }

        if let toolPath = findToolPath(), FileManager.default.fileExists(atPath: toolPath) {
            return toolPath
        }

        return nil
    }

    ///Attempts to find the path for AppClipCodeGenerator, if it cannot be found at the default location
    private func findToolPath() -> String? {
        let process = Process()
        let pipe = Pipe()
        let errorPipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", "/usr/bin/which AppClipCodeGenerator"]

        process.environment = ["PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"]

        process.standardOutput = pipe
        process.standardError = errorPipe

        do {
            try process.run()
            process.waitUntilExit()

            let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let error = String(data: errorData, encoding: .utf8) ?? "No error"

            print("Output: \(output ?? "nil")")
            print("Error: \(error)")

            return (output?.isEmpty == false) ? output : nil
        } catch {
            print("Error running process: \(error)")
            return nil
        }
    }
}
