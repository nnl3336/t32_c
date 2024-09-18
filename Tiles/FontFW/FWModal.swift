//
//  FWModal.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/08.
//

import SwiftUI

struct FWModal: View {
    @EnvironmentObject var fsClass: FSClass
    @EnvironmentObject var fwClass: FWClass
    @EnvironmentObject var settingProfile: SettingProfile
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            List(FWEnum.allCases, id: \.self, selection: $fwClass.fwEnum) { fw in
                HStack {
                    Text("\(fw.rawValue)")
                    Spacer()
                    if fw == fwClass.fwEnum {
                        Text("✓")
                            .foregroundColor(.blue)
                    }
                }.listRowBackground(settingProfile.dark ? Color.black.opacity(0.7) : Color.white)
                    .foregroundColor(settingProfile.textColor)
            }
            .onDisappear(perform: {fwUserDefaults()})
            .background(settingProfile.backColor)
            .scrollContentBackground(.hidden)

            ZStack {
                Rectangle()
                    .foregroundColor(settingProfile.backColor)
                Text("Current Text").font(fsClass.fs).fontWeight(fwClass.fw).foregroundColor(settingProfile.textColor)
            }
        }
    }
    
    func fwUserDefaults() {
        UserDefaults.standard.set((fwClass.fwEnum ?? .medium).rawValue, forKey: "isFW")
    }
}

