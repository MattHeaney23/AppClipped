//
//  NSImage+ProcessImageToColors.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//

import AppKit

extension NSImage {
    func processImageToColors() -> [NSColor] {
        guard let bitmap = NSBitmapImageRep(data: self.tiffRepresentation!) else { return [] }

        var colorCounts: [NSColor: Int] = [:]

        for x in stride(from: 0, to: bitmap.pixelsWide, by: 10) {
            for y in stride(from: 0, to: bitmap.pixelsHigh, by: 10) {
                if let color = bitmap.colorAt(x: x, y: y) {
                    let roundedColor = color.roundColor()
                    colorCounts[roundedColor, default: 0] += 1
                }
            }
        }

        let sortedColors = colorCounts.sorted { $0.value > $1.value }
        let topColors = sortedColors.prefix(10).map { $0.key }

        return topColors
    }
}
