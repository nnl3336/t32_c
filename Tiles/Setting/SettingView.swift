//
//  SettingView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/02.
//

import SwiftUI

struct SettingView: View {

@Binding var showModal: Bool
@ObservedObject var settingProfile: SettingProfile

var body: some View {

Toggle(isOn: $settingProfile.dark) {Text("DarkMode")}



}

// func

}

