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

        // Use the NSColor extension method to check distinctiveness
        if let distinctColor = candidates.first(where: { $0.isHighlyDistinct(from: primary) }) {
            return distinctColor
        }

        // If no distinct color is found, pick black or white with improved contrast logic
        return primary.pickHighContrastBlackOrWhite()
    }
}
