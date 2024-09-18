//
//  SettingProfile.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/02/28.
//

import SwiftUI

class SettingProfile: ObservableObject {
    @AppStorage("dark") var dark = false {
        didSet {
            objectWillChange.send()
        }
    }
    var backColor: Color {
        return dark ? .black : .white
    }
    var textColor: Color {
        return dark ? .white : .black
    }
    
    @AppStorage("TimeMode") var isTime = false {
        didSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("TileMode") var isTile = false {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var settingView = false
}


