//
//  FSClass.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/08.
//

import SwiftUI
import Foundation

class FSClass: ObservableObject {
    @Published var fsEnum: FSEnum? = .body

    var fs: Font {
        return fsEnum?.fs ?? .body
    }
    var fsString: String {
        return fsEnum?.fsString ?? "body"
    }

    init() {
        if let rawValue = UserDefaults.standard.string(forKey: "isFS") {
            fsEnum =  FSEnum(rawValue: rawValue)
        }
    }
}
