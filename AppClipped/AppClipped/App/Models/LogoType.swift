//
//  LogoType.swift
//  AppClipped
//
//  Created by Matt Heaney on 04/03/2025.
//

enum LogoType: String {
    case logoIncluded = "logoIncluded"
    case logoNotIncluded = "logoNotIncluded"

    var showLogoParameter: String {
        switch self {
        case .logoIncluded:
            return "badge"
        case .logoNotIncluded:
            return "none"
        }
    }
}
