//
//  FSEnum.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/08.
//

import SwiftUI

enum FSEnum: String, CaseIterable {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case subheadline
    case body

    var fs: Font {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .body:
            return .body
        }
    }

    var fsString: String {
        switch self {
        case .largeTitle:
            return "largeTitle"
        case .title:
            return "title"
        case .title2:
            return "title2"
        case .title3:
            return "title3"
        case .headline:
            return "headline"
        case .subheadline:
            return "subheadline"
        case .body:
            return "body"
        }
    }

}
