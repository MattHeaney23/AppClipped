//
//  AppClipGeneratorState.swift
//  AppClipped
//
//  Created by Matt Heaney on 09/03/2025.
//

enum AppClipGeneratorState: Equatable {
    case ready
    case loading
    case error(Error)

    static func == (lhs: AppClipGeneratorState, rhs: AppClipGeneratorState) -> Bool {
        switch (lhs, rhs) {
        case (.ready, .ready), (.loading, .loading):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
