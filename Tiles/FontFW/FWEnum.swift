//
//  FWEnum.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/08.
//

import SwiftUI

enum FWEnum: String, CaseIterable {
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy

    var fw: Font.Weight {
        switch self {
        case .thin:
            return .thin
        case .light:
            return .light
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold:
            return .bold
        case .heavy:
            return .heavy
        }
    }

    var fwString: String {
        switch self {
        case .thin:
            return "thin"
        case .light:
            return "light"
        case .regular:
            return "regular"
        case .medium:
            return "medium"
        case .semibold:
            return "semibold"
        case .bold:
            return "bold"
        case .heavy:
            return "heavy"
        }
    }

}
