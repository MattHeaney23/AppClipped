//
//  NSColor+PickHighContrastBlackOrWhite.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//

import AppKit

extension NSColor {
    // Picks black or white based on the primary color’s brightness and contrast needs
    func pickHighContrastBlackOrWhite() -> NSColor {
        guard let hsb = self.usingColorSpace(.sRGB) else { return .black }

        let brightness = hsb.brightnessComponent

        if brightness > 0.7 {
            return .black
        } else if brightness < 0.3 {
            return .white
        } else {
            return brightness > 0.5 ? .black : .white
        }
    }
}
