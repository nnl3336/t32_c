//
//  FWClass.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/08.
//

import SwiftUI
import Foundation

class FWClass: ObservableObject {
    @Published var fwEnum: FWEnum? = .medium

    var fw: Font.Weight {
        return fwEnum?.fw ?? .medium
    }
    var fwString: String {
        return fwEnum?.fwString ?? "medium"
    }

    init() {
        if let rawValue = UserDefaults.standard.string(forKey: "isFW") {
            fwEnum = FWEnum(rawValue: rawValue)
        }
    }
}
