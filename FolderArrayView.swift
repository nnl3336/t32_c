//
//  FolderArrayView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/15.
//

import SwiftUI

struct FolderArrayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.makeDate, ascending: true)], animation: .default) private var tiles: FetchedResults<Item>
    @State var sheetAddView = false
    @State var sheetEditView = false
    @State private var selectedCircle: Int? = nil
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default) private var items: FetchedResults<Item>
    @State var smakeDate = Date()
    @State var isRed = false
    @State var isBlue = false
    @State var isYellow = false
    @State var isGreen = false
    @State var isPink = false
    @State var editViewSheet = false
    
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var sisRed = false
    @State private var sisBlue = false
    @State private var sisYellow = false
    @State private var sisGreen = false
    @State private var sisPink = false
    @State private var sisCheck = false
    @State private var sisNotCheck = false
    @State private var sisLiked = false
    
    @State private var showContextMenu = false
    @State private var showContextMenu2 = false

    @State var isEditing = false
    @State var selectedItems: Set<Item> = []
    
    @State var darkMode = false
    
    @State var folderMakeAlart = false
    @State var textFieldText = ""
    
    @EnvironmentObject var settingProfile: SettingProfile

    @EnvironmentObject var fsClass: FSClass

    @EnvironmentObject var fwClass: FWClass
    
    @EnvironmentObject var selectedItemsManager: SelectedItemsManager

    @EnvironmentObject var accentColorClass: AccentColorClass
    
    @State var transferModal = false
    
    @State var dustAlert = false
    
    var folder: Folder

    var body: some View {
        if settingProfile.isTile {
            LazyVGridModeFolderArrayView(folder: folder)
        } else {
            ListModeFolderArrayView(folder: folder)
        }
        
        }
    
    func search(text: String, folder: Folder) {
        var predicates = [NSPredicate]()
        
        if !text.isEmpty {
            let textPredicate = NSPredicate(format: "text contains[c] %@ AND folder == %@", text, folder)
            predicates.append(textPredicate)
}

        // すべての条件が空の場合、nilを設定
        if predicates.isEmpty {
            items.nsPredicate = nil
        } else {
            // 条件がある場合、NSCompoundPredicate を作成して設定
            items.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }

    func onCheck(item: Item) {
            if let index = folderItems.firstIndex(of: item){
    selectedItems.insert(folderItems[index])
            }
        }
    

    func colorForItem(_ item: Item) -> Color {
        if item.isRed {
            return .red
        } else if item.isBlue {
            return .cyan
        } else if item.isYellow {
            return .yellow
        } else if item.isGreen {
            return .green
        } else if item.isPink {
            return .pink
        } else {
            return .white
        }
    }

    /* func selectCircle(_ circleNumber: Int) {
            if let currentSelection = selectedCircle, currentSelection == circleNumber {
                selectedCircle = nil
            } else {
                selectedCircle = circleNumber
            }
        } */
    
    func doMultipleDust(selectedItems: Set<Item>) {
        selectedItemsManager.selectedItems.forEach { item in
            viewContext.delete(item)
            try? viewContext.save()
            selectedItemsManager.selectedItems = []
        }
    }
    
    func doMultipleDelete(selectedItems: Set<Item>) {
        selectedItems.forEach { item in
            viewContext.delete(item)
            try? viewContext.save()
            self.selectedItems = []
        }
    }

    func doMultipleCheck(selectedItems: Set<Item>) {
        selectedItems.forEach { item in
        item.isCheck.toggle()
            try? viewContext.save()
            self.selectedItems = []
        }
    }
    
    func doMultipleLike(selectedItems: Set<Item>) {
        selectedItems.forEach { item in
        item.isLiked.toggle()
            try? viewContext.save()
            self.selectedItems = []
        }
    }
    
    func toggleSelection(item: Item) {
            if selectedItems.contains(item) {
                selectedItems.remove(item)
            } else {
                selectedItems.insert(item)
            }
        }
    
    let itemFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        return formatter
    }()
    
    let itemFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    
    
    func makeFolder() {
    let newFolder = Folder(context: viewContext)
    newFolder.folderName = textFieldText
    newFolder.folderMadeTime = Date()
    try? viewContext.save()
    }
    
    func doLike(item: Item) {
            if let index = items.firstIndex(of: item){
                items[index].isLiked.toggle()
                try? viewContext.save()
            }
        }
    
    func doCheck(item: Item) {
            if let index = items.firstIndex(of: item){
                items[index].isCheck.toggle()
                try? viewContext.save()
            }
        }

    func doDelete(item: Item) {
        if let index = items.firstIndex(of: item){
            viewContext.delete(items[index])
            try? viewContext.save()
        }
    }
    
    func isSelected(item: Item) -> Bool {
            selectedItems.contains(item)
        }
    
    func fisSelected1() {
        self.sisRed.toggle()
        self.sisBlue = false
        self.sisYellow = false
        self.sisGreen = false
        self.sisPink = false
    }
    
    func fisSelected2() {
        self.sisRed = false
        self.sisBlue.toggle()
        self.sisYellow = false
        self.sisGreen = false
        self.sisPink = false
    }
    
    func fisSelected3() {
        self.sisRed = false
        self.sisBlue = false
        self.sisYellow.toggle()
        self.sisGreen = false
        self.sisPink = false
    }
    
    func fisSelected4() {
        self.sisRed = false
        self.sisBlue = false
        self.sisYellow = false
        self.sisGreen.toggle()
        self.sisPink = false
    }
    
    func fisSelected5() {
        self.sisRed = false
        self.sisBlue = false
        self.sisYellow = false
        self.sisGreen = false
        self.sisPink.toggle()
    }
    
     var folderItems: [Item] {
             if let folderItems = folder.item?.allObjects as? [Item] {
                 return folderItems
             }
         return [] // デフォルトの空の配列を返す
    }
    

}

