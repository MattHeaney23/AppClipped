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

        let sortedColors = image.processImageToColors()

        guard let primaryColor = sortedColors.first else { return [Color.black, Color.white] }

        let candidates = sortedColors.dropFirst().map { $0 }
        let secondColor = findNextHighlyDistinctColor(primaryColor, candidates: candidates)

        return [Color(nsColor: primaryColor), Color(nsColor: secondColor)]
    }

    private func findNextHighlyDistinctColor(_ primary: NSColor, candidates: [NSColor]) -> NSColor {

        // Find the next suitable color to use
        if let distinctColor = candidates.first(where: { $0.isHighlyDistinct(from: primary) }) {
            return distinctColor
        }

        // If no distinct color is found, deice if black or white would be the best choice
        return primary.pickHighContrastBlackOrWhite()
    }
}
