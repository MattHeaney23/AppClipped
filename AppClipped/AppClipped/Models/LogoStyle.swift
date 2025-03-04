//
//  LogoStyle.swift
//  AppClipped
//
//  Created by Matt Heaney on 04/03/2025.
//

enum LogoStyle: String {
    case includeAppClipLogo = "includeAppClipLogo"
    case doNotIncludeAppClipLogo = "doNotIncludeAppClipLogo"

    var showLogoParameter: String {
        switch self {
        case .includeAppClipLogo:
            return "badge"
        case .doNotIncludeAppClipLogo:
            return "none"
        }
    }
}
