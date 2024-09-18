//
//  AccentColorModal.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/11.
//

import SwiftUI

struct AccentColorModal: View {
    @EnvironmentObject var fsClass: FSClass
    @EnvironmentObject var fwClass: FWClass
    @EnvironmentObject var settingProfile: SettingProfile
    @EnvironmentObject var accentColorClass: AccentColorClass
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            List(AccentColorEnum.allCases, id: \.self, selection: $accentColorClass.accentColorEnum) { ac in
                HStack {
                    Text("\(ac.rawValue)")
                    Spacer()
                    if ac == accentColorClass.accentColorEnum {
                        Text("✓")
                            .foregroundColor(.blue)
                    }
                }.listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)
                    .foregroundColor(settingProfile.textColor)
            }
            .background(settingProfile.backColor)
            .scrollContentBackground(.hidden)
            .onDisappear(perform: {fsUserDefaults()})
            
        }
    }
    
    func fsUserDefaults() {
        UserDefaults.standard.set((accentColorClass.accentColorEnum ?? .blue).rawValue, forKey: "isAC")
    }
}
