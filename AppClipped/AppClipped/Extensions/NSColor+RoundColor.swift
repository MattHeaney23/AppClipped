//
//  NSColor+RoundColor.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//

import AppKit

extension NSColor {
    ///Rounds the color in the RGB to 1 decimal place
    func roundColor() -> NSColor {
        guard let rgbColor = self.usingColorSpace(.sRGB) else { return self }

        let roundedRed = round(rgbColor.redComponent * 10) / 10
        let roundedGreen = round(rgbColor.greenComponent * 10) / 10
        let roundedBlue = round(rgbColor.blueComponent * 10) / 10

        return NSColor(red: roundedRed, green: roundedGreen, blue: roundedBlue, alpha: 1)
    }
}
