//
//  TilesApp.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/02/22.
//

import SwiftUI

@main
struct TilesApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var selectedItemsManager = SelectedItemsManager()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(FSClass())
                .environmentObject(FWClass())
                .environmentObject(SettingProfile())
                .environmentObject(OtherObserved())
                .environmentObject(AccentColorClass())
                .environmentObject(selectedItemsManager)
                .environmentObject(MessageCopyBalloon())
                .environmentObject(SortFolderClass())
        }
    }
}
