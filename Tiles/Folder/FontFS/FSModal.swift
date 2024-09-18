//
//  FSModal.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/08.
//

import SwiftUI

struct FSModal: View {
    @EnvironmentObject var fsClass: FSClass
    @EnvironmentObject var fwClass: FWClass
    @EnvironmentObject var settingProfile: SettingProfile
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            List(FSEnum.allCases, id: \.self, selection: $fsClass.fsEnum) { fs in
                HStack {
                    Text("\(fs.rawValue)")
                    Spacer()
                    if fs == fsClass.fsEnum {
                        Text("✓")
                            .foregroundColor(.blue)
                    }
                }.listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)
                    .foregroundColor(settingProfile.textColor)
            }
            .background(settingProfile.backColor)
            .scrollContentBackground(.hidden)
            .onDisappear(perform: {fsUserDefaults()})
            
            ZStack {
                Rectangle()
                    .foregroundColor(settingProfile.backColor)
                Text("Current Text").font(fsClass.fs).fontWeight(fwClass.fw).foregroundColor(settingProfile.textColor)
            }
        }
    }
    
    func fsUserDefaults() {
        UserDefaults.standard.set((fsClass.fsEnum ?? .body).rawValue, forKey: "isFS")
    }
}
