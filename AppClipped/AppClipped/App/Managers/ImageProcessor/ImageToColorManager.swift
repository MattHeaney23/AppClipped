//
//  ImageToColorManager.swift
//  AppClipped
//
//  Created by Matt Heaney on 12/03/2025.
//

import AppKit
import SwiftUI

class ImageToColorManager {

    func processImage(_ image: NSImage) -> [Color] {
        guard let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!) else { return [] }

        var colorCounts: [NSColor: Int] = [:]

        // Sample every 10 pixels for efficiency
        for x in stride(from: 0, to: bitmap.pixelsWide, by: 10) {
            for y in stride(from: 0, to: bitmap.pixelsHigh, by: 10) {
                if let color = bitmap.colorAt(x: x, y: y) {
                    let roundedColor = roundColor(color)
                    colorCounts[roundedColor, default: 0] += 1
                }
            }
        }

        // Get the top 5 most frequent colors
        let topColors = colorCounts.sorted { $0.value > $1.value }.prefix(5).map { $0.key }

        guard let primaryColor = topColors.first else { return [] }

        // Find the best contrasting color from the top 5
        let secondColor = topColors.dropFirst().max {
            contrastScore($0, primaryColor) < contrastScore($1, primaryColor)
        }

        return [Color(nsColor: primaryColor)] + (secondColor.map { [Color(nsColor: $0)] } ?? [])
    }

    // Round colors to reduce minor variations
    private func roundColor(_ color: NSColor) -> NSColor {
        guard let rgbColor = color.usingColorSpace(.sRGB) else { return color }

        let roundedRed = round(rgbColor.redComponent * 10) / 10
        let roundedGreen = round(rgbColor.greenComponent * 10) / 10
        let roundedBlue = round(rgbColor.blueComponent * 10) / 10

        return NSColor(red: roundedRed, green: roundedGreen, blue: roundedBlue, alpha: 1)
    }

    // Compute contrast score based on luminance and hue difference
    private func contrastScore(_ color1: NSColor, _ color2: NSColor) -> CGFloat {
        let lumDiff = abs(luminance(color1) - luminance(color2))
        let hueDiff = abs(hue(color1) - hue(color2))

        return lumDiff + (hueDiff * 0.5) // Give more weight to luminance for visibility
    }

    // Get luminance (brightness perception)
    private func luminance(_ color: NSColor) -> CGFloat {
        guard let rgb = color.usingColorSpace(.sRGB) else { return 0 }
        return 0.299 * rgb.redComponent + 0.587 * rgb.greenComponent + 0.114 * rgb.blueComponent
    }

    // Get hue value (color identity)
    private func hue(_ color: NSColor) -> CGFloat {
        guard let hsb = color.usingColorSpace(.deviceRGB) else { return 0 }
        return hsb.hueComponent
    }
}
