//
//  FolderArrayView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/05.
//

import SwiftUI

struct LazyVGridModeFolderArrayView: View {

    @Environment(\.managedObjectContext) private var viewContext
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default) private var items: FetchedResults<Item>
    @State var editViewSheet = false
@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ Folder.folderMadeTime, ascending: true)], animation: .default) private var  folders: FetchedResults<Folder>
    @Environment(\.dismiss) var dismiss
    
    @State var searchText: String = ""
    @State var isEditMode: EditMode = .inactive
    @State var transferModal = false
    @State var dustAlert = false
    @State var selectionValue: Set<Item> = []
    
    @State var sheetAddView = false
    
    @State var isEditing = false
    @State var selectedItems: Set<Item> = []
    
    @State private var isSearching = false
    @State private var sisRed = false
    @State private var sisBlue = false
    @State private var sisYellow = false
    @State private var sisGreen = false
    @State private var sisPink = false
    @State private var sisCheck = false
    @State private var sisNotCheck = false
    @State private var sisLiked = false
    
    @EnvironmentObject var settingProfile: SettingProfile

    @EnvironmentObject var fsClass: FSClass

    @EnvironmentObject var fwClass: FWClass

    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var selectedItemsManager: SelectedItemsManager
    
    var folder: Folder
    
    @State var textFieldText = ""

    var body: some View {
        
        GeometryReader { geometry in
            
            NavigationStack {
                
                if selectedItemsManager.isEditing {
                    HStack {
                    VStack {
                        Image(systemName: "trash")
                            .foregroundColor(.blue)
                        Button(action: {
                            doMultipleDust(selectedItems: selectedItemsManager.selectedItems)
                        }) {
                            Text("trash")
                        }
                    }
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                        Button(action: {
                            doMultipleCheck(selectedItems: selectedItemsManager.selectedItems)
                        }) {
                            Text("check")
                        }
                    }
                    VStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.blue)
                        Button(action: {
                            doMultipleLike(selectedItems: selectedItemsManager.selectedItems)
                        }) {
                            Text("favorite")
                        }
                    }
                    VStack {
                        Image(systemName: "folder.circle")
                            .foregroundColor(.blue)
                        Button(action: {
                            transferModal.toggle()
                        }) {
                            Text("transfer")
                        }
                    }
                    Button(action: {
                        selectedItemsManager.isEditing.toggle()
                        selectedItemsManager.selectedItems = []
                    }) {
                        Text("cancel")
                    }
                }
            }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(folderItems, id: \.self) { item in
                            ZStack {
                                ItemView(editViewSheet: $editViewSheet, item: item)
                                    .onTapGesture {
                                        if selectedItemsManager.isEditing {
                                            self.toggleSelection(item: item)
                                        } else {
                                            self.editViewSheet.toggle()
                                        }
                                    }
                                    .sheet(isPresented: $editViewSheet) {
                                        EditView(item: item)                                            
                                            .presentationDetents([
                                                .fraction(0.95)
                                            ])
                                    }
                                    .frame(width: geometry.size.width * 1/5, height: geometry.size.height * 1/10)
                                    .onLongPressGesture(perform: {
                                        selectedItemsManager.isEditing.toggle()
                                        onCheck(item: item)
                                    })
                                if isSelected(item: item) {
                                    ZStack {
                                        Rectangle()
                                            .frame(width: geometry.size.width * 1/5, height: geometry.size.height * 1/10)
                                            .foregroundStyle(.black.opacity(0.4))
                                        Image(systemName: "checkmark.circle.fill")
                                    }.onTapGesture(perform: {toggleSelection(item: item)})
                                }
                            }
                        }
                    }
                }
                .onChange(of: searchText) { newValue in
                    search(text: searchText, isRed: sisRed, isBlue: sisBlue, isYellow: sisYellow, isGreen: sisGreen, isPink: sisPink, isCheck: sisCheck, isLiked: sisLiked)
                }
                .onChange(of: [sisRed, sisBlue, sisYellow, sisGreen, sisPink, sisCheck, sisLiked]) { newValue in
                    search(text: searchText, isRed: sisRed, isBlue: sisBlue, isYellow: sisYellow, isGreen: sisGreen, isPink: sisPink, isCheck: sisCheck, isLiked: sisLiked)
                }
                .scrollContentBackground(.hidden)
                .background(settingProfile.backColor)
                .navigationTitle(folder.folderName ?? "a").navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "search")
                .environment(\.editMode, $isEditMode)
                .gesture(longPressGesture)
                .scrollContentBackground(.hidden)
                .background(.white)
                .toolbarBackground(settingProfile.backColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        if !selectedItemsManager.selectedItems.isEmpty {
                            Button(action: {transferModal.toggle()}) {Text("transfer")}
                        }
                        if isEditMode == .active{
                            Button(action: {self.dustAlert.toggle()}) {Text("dust")}
                            Button(action: {self.transferModal.toggle()}) {Text("transfer")}
                            Button(action: {self.isEditMode = .inactive}) {Text("cancel")}
                        }
                        Button(action: { self.sheetAddView.toggle() }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $transferModal) {
                TransferModal(transferModal: $transferModal)
                }
                .sheet(isPresented: $sheetAddView) {
                    AddView(showModal: $sheetAddView, folder: folder)
                        .presentationDetents([
                            .fraction(0.95)
                        ])
                }
                .alert("Dust?", isPresented: $dustAlert){
                    Text("デバイスからは削除されません")
                    Button(role: .cancel, action: {}, label: {Text("cancel")})
                    Button(role: .destructive, action: {itemsDust(selectionValue: selectionValue)}, label: {Text("Dust")})
                }
                
            }
            
        }
        
    }
    
    func doMultipleDust(selectedItems: Set<Item>) {
        selectedItemsManager.selectedItems.forEach { item in
            viewContext.delete(item)
            try? viewContext.save()
            selectedItemsManager.selectedItems = []
        }
    }
    
    func search(text: String, isRed: Bool, isBlue: Bool, isYellow: Bool, isGreen: Bool, isPink: Bool, isCheck: Bool, isLiked: Bool) {
        var predicates = [NSPredicate]()
        
        if !text.isEmpty {
            let textPredicate = NSPredicate(format: "text contains[c] %@", text)
            predicates.append(textPredicate)
        }else{
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("text") }) {
                predicates.remove(at: index)
            }
        }
        
        if sisRed {
            let isRedPredicate = NSPredicate(format: "isRed == %@", NSNumber(value: true))
            predicates.append(isRedPredicate)
        }else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isRed") }) {
                predicates.remove(at: index)
            }
        }
        if sisBlue {
            let isBluePredicate = NSPredicate(format: "isBlue == %@", NSNumber(value: true))
            predicates.append(isBluePredicate)
        }else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isBlue") }) {
                predicates.remove(at: index)
            }
        }
        if sisYellow {
            let isYellowPredicate = NSPredicate(format: "isYellow == %@", NSNumber(value: true))
            predicates.append(isYellowPredicate)
        }else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isYellow") }) {
                predicates.remove(at: index)
            }
        }
        if sisGreen {
            let isGreenPredicate = NSPredicate(format: "isGreen == %@", NSNumber(value: true))
            predicates.append(isGreenPredicate)
        }else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isGreen") }) {
                predicates.remove(at: index)
            }
        }
        if sisPink {
            let isPinkPredicate = NSPredicate(format: "isPink == %@", NSNumber(value: true))
            predicates.append(isPinkPredicate)
        }else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isPink") }) {
                predicates.remove(at: index)
            }
        }
        if sisCheck {
            let isCheckPredicate = NSPredicate(format: "isCheck == true")
            predicates.append(isCheckPredicate)
        } else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isCheck == true") }) {
                predicates.remove(at: index)
            }
        }

        if sisNotCheck {
            let isNotCheckPredicate = NSPredicate(format: "isCheck == false || isCheck == nil")
            predicates.append(isNotCheckPredicate)
        } else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isCheck == false || isCheck == nil") }) {
                predicates.remove(at: index)
            }
        }
        if sisLiked {
            let isLikedPredicate = NSPredicate(format: "isLiked == %@", NSNumber(value: true))
            predicates.append(isLikedPredicate)
        }else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isLiked") }) {
                predicates.remove(at: index)
            }
        }
        

        
        // すべての条件が空の場合、nilを設定
        if predicates.isEmpty {
            items.nsPredicate = nil
        } else {
            // 条件がある場合、NSCompoundPredicate を作成して設定
            items.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
    func transfer(folder: Folder) {
            if let index = folders.firstIndex(of: folder){
                selectedItemsManager.selectedItems.map{$0}.forEach{ value in
                    value.folder =  folders[index]
                }
                
                try? viewContext.save()
            }
        transferModal.toggle()
        selectedItemsManager.selectedItems = []
        }
    
    func doDust(item: Item) {
    if let index = items.firstIndex(of: item){
    items[index].isDust.toggle()
                try? viewContext.save()
                self.presentationMode.wrappedValue.dismiss()
        }
    }

    func itemsDust(selectionValue: Set<Item>) {
        selectionValue.forEach { item in
           // item.isDust = true
    try? viewContext.save()
        self.isEditMode =  .inactive
    }
    }
    
var longPressGesture: some Gesture {
    LongPressGesture(minimumDuration: 1)
        .onEnded { _ in
            // 長押しされたときの処理
            isEditMode = .active
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
    let filteredItems = items.filter { $0.folder == folder }
    return filteredItems
     }
    

}

