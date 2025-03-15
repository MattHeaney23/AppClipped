//
//  LogoBasedColorSelectionViewModel.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//

import SwiftUI

@MainActor
@Observable
class LogoBasedColorSelectionViewModel {
    var customForegroundColor: Color = .blue
    var customBackgroundColor: Color = .white
    var uploadedImage: NSImage? = nil
}
