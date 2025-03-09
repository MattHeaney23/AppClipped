//
//  AppClipToolManager.swift
//  AppClipped
//
//  Created by Matt Heaney on 08/03/2025.
//

import Cocoa

///Handles locating the AppClipCodeGenerator tool on the user's system
class AppClipToolManager {

    public func isToolInstaller() -> Bool {
        return pathForAppClipCodeGenerator() != nil
    }

    public func pathForAppClipCodeGenerator() -> String? {
        if let toolPath = findToolPath(), FileManager.default.fileExists(atPath: toolPath) {
            return toolPath
        }

        return nil
    }

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
