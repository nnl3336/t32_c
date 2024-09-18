//
//  AccentColorClass.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/11.
//

import SwiftUI

class AccentColorClass: ObservableObject {
    @Published var accentColorEnum: AccentColorEnum? = .blue

    var ac: Color {
        return accentColorEnum?.ac ?? .blue
    }
    var acString: String {
        return accentColorEnum?.acString ?? "blue"
    }

    init() {
        if let rawValue = UserDefaults.standard.string(forKey: "isAC") {
            accentColorEnum =  AccentColorEnum(rawValue: rawValue)
        }
    }
}
