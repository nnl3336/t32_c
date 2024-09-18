//
//  SortFolderClass.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/14.
//

import SwiftUI

class SortFolderClass: ObservableObject {
    @Published var sortFolderEnum: SortFolderEnum? = .byMakeDate

    var sF: [SortDescriptor<Folder>] {
        return sortFolderEnum?.sF ?? [SortDescriptor<Folder>(\.folderMadeTime, order: .forward)]
    }

    init() {
        if let rawValue = UserDefaults.standard.string(forKey: "isSF") {
            sortFolderEnum = SortFolderEnum(rawValue: rawValue)
        }
    }
    
    func saveSortType(_ sortType: SortFolderEnum) {
        UserDefaults.standard.set((self.sortFolderEnum ?? .byMakeDate).rawValue, forKey: "isSF")
        print("a")
    }
    
    func bindingForSelection() -> Binding<SortFolderEnum?> {
        return Binding<SortFolderEnum?>(
            get: { self.sortFolderEnum },
            set: { self.sortFolderEnum = $0 }
        )
    }
}
