//
//  NSColor+IsHighlyDistinct.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//

import AppKit

extension NSColor {
    /// Checks if another color is highly distinct based on hue and brightness differences
    func isHighlyDistinct(from other: NSColor) -> Bool {
        guard let selfHSB = self.usingColorSpace(.sRGB),
              let otherHSB = other.usingColorSpace(.sRGB) else { return false }

        let hueDiff = abs(selfHSB.hueComponent - otherHSB.hueComponent)
        let brightnessDiff = abs(selfHSB.brightnessComponent - otherHSB.brightnessComponent)

        return hueDiff > 0.5 || brightnessDiff > 0.6
    }
}
