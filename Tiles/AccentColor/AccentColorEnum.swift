//
//  AccentColorEnum.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/11.
//

import SwiftUI

enum AccentColorEnum: String, CaseIterable, Identifiable {
    case blue
    case orange
    case gray

    var id: String { self.rawValue }

    var ac: Color {
        switch self {
        case .blue:
            return .blue
        case .orange:
            return .orange
        case .gray:
            return .gray
        }
    }
    
    var acString: String {
        switch self {
        case .blue:
            return "blue"
        case .orange:
            return "orange"
        case .gray:
            return "gray"
        }
    }
}
