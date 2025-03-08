//
//  ColorStyle.swift
//  AppClipped
//
//  Created by Matt Heaney on 08/03/2025.
//

import SwiftUI

enum SelectedColorMode {
    case index(indexID: Int)
    case custom(foregroundColour: Color, backgroundColor: Color)
}
