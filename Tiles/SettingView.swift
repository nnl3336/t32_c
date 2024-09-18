//
//  SettingView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/08.
//

import SwiftUI

struct SettingView: View {
    
@Binding var settingView: Bool

    @EnvironmentObject var settingProfile: SettingProfile

    @EnvironmentObject var fsClass: FSClass
    
    @EnvironmentObject var fwClass: FWClass
    
    @EnvironmentObject var accentColorClass: AccentColorClass

    

var body: some View {

NavigationStack{

List{

Toggle(isOn: $settingProfile.dark) {Text("DarkMode")}.listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)

    NavigationLink(destination: FSModal(), label: {
HStack{
Text("FontSize")
Spacer()
    Text(fsClass.fsString)
}
}).listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)

    NavigationLink(destination: FWModal(), label: {
HStack{
Text("FontWeight")
Spacer()
    Text(fwClass.fwString)
}
}).listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)

Toggle(isOn: $settingProfile.isTime) {Text("TimeMode")}.listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)

Toggle(isOn: $settingProfile.isTile) {Text("TileMode")}.listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)
    
    NavigationLink(destination: AccentColorModal(), label: {
HStack{
Text("AccentColor")
Spacer()
    Text(accentColorClass.acString)
}
}).listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)

//

}
.scrollContentBackground(.hidden)
.background(settingProfile.backColor)
.foregroundColor(settingProfile.dark ? .white : .black)

}

}

// func

}
