//
//  ContentView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/02/22.
//

import SwiftUI
import CoreData

struct MaintView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.makeDate, ascending: false)], animation: .default) private var tiles: FetchedResults<Item>
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
    
    @State var isTapping = false

    var body: some View {
        GeometryReader { geometry in
            
            NavigationView {
                VStack{
                    SearchBar(text: $searchText, isSearching: $isSearching, sisRed: $sisRed, sisBlue: $isBlue, sisYellow: $sisYellow, sisGreen: $sisGreen, sisPink: $sisPink, sisCheck: $sisCheck, sisNotCheck: $sisNotCheck, sisLiked: $sisLiked)
                        .disabled(isEditing)
                    
                    if isSearching {
                        HStack{
                            ColorCircle(color: .red, isSelected: $sisRed).onTapGesture(perform: {fisSelected1()})
                            ColorCircle(color: .blue, isSelected: $sisBlue).onTapGesture(perform: {fisSelected2()})
                            ColorCircle(color: .yellow, isSelected: $sisYellow).onTapGesture(perform: {fisSelected3()})
                            ColorCircle(color: .green, isSelected: $sisGreen).onTapGesture(perform: {fisSelected4()})
                            ColorCircle(color: .pink, isSelected: $sisPink).onTapGesture(perform: {fisSelected5()})
                        }
                        
                        HStack{
                            Image(systemName: "pencil.circle.fill")
                            Text(sisCheck ? "✓" : "").foregroundColor(.blue)
                        }.onTapGesture(perform: {
                            if sisCheck {
                                self.sisCheck.toggle()
                            } else {
                                self.sisCheck.toggle()
                                if sisNotCheck {
                                    self.sisNotCheck.toggle()
                                } else {
                                }
                            }
                        })
                        
                        HStack{
                            Image(systemName: "pencil.circle")
                            Text(sisNotCheck ? "✓" : "").foregroundColor(.blue)
                        }.onTapGesture(perform: {
                            if sisNotCheck {
                                self.sisNotCheck.toggle()
                            } else {
                                self.sisNotCheck.toggle()
                                if sisCheck {
                                    self.sisCheck.toggle()
                                } else {
                                }
                            }
                        })
                        
                        HStack{
                            Image(systemName: "heart.fill")
                            Text(sisLiked ? "✓" : "").foregroundColor(.blue)
                        }.onTapGesture(perform: {self.sisLiked.toggle()})
                    }
                    
                    if !isSearching {
                        Rectangle()
                            .frame(height: geometry.size.height * 1/16)
                            .foregroundColor(settingProfile.backColor)
                    }
                    
                    if selectedItemsManager.isEditing {
                        HStack {
                            VStack {
                                Image(systemName: "trash")
                                    .foregroundColor(.blue)
                                Button(action: {
                                    dustAlert.toggle()
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
                                    selectedItemsManager.isEditing.toggle()
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
                            ForEach(notDustArray, id: \.self) { item in
                                ZStack {
                                    ItemView(editViewSheet: $editViewSheet, item: item)
                                        .sheet(isPresented: $editViewSheet) {
                                            EditView(item: item)
                                                .presentationDetents([
                                                    .fraction(0.95)
                                                ])
                                        }
                                        .frame(width: geometry.size.width * 1/5, height: geometry.size.height * 1/10)
                                    if isSelected(item: item) {
                                        ZStack {
                                            Rectangle()
                                                .frame(width: geometry.size.width * 1/5, height: geometry.size.height * 1/10)
                                                .foregroundStyle(.black.opacity(0.4))
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                    }
                                    //
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(settingProfile.backColor)
                    }
                    .navigationTitle("")
                    .accentColor(accentColorClass.ac)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                        }
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button(action: {self.folderMakeAlart.toggle()}){Image(systemName: "folder")}
                        }
                    }
                    .sheet(isPresented: $sheetAddView) {
                        AddView(showModal: $sheetAddView)
                            .presentationDetents([
                                .fraction(0.95)
                            ])
                    }
                    
                    if isSearching {
                        Rectangle()
                            .fill(.black.opacity(0.9))
                            .onTapGesture {
                                isSearching.toggle()
                            }
                    }
                }
                
                .onChange(of: searchText) { newValue in
                    search(text: searchText, isRed: sisRed, isBlue: isBlue, isYellow: sisYellow, isGreen: sisGreen, isPink: sisPink, isCheck: sisCheck, isLiked: sisLiked)
                }
                .onChange(of: [sisRed, sisBlue, sisYellow, sisGreen, sisPink, sisCheck, sisLiked]) { newValue in
                    search(text: searchText, isRed: sisRed, isBlue: isBlue, isYellow: sisYellow, isGreen: sisGreen, isPink: sisPink, isCheck: sisCheck, isLiked: sisLiked)
                }
                .alert("make Folder ?", isPresented: $folderMakeAlart){
                    TextField("text", text: $textFieldText)
                        .textInputAutocapitalization(.never)
                    Button(role: .cancel, action: {self.folderMakeAlart.toggle()}, label: {Text("cancel")})
                    Button(role: .none, action: {makeFolder()}, label: {Text("Make")})
                    
                } message: {
                    Text("")
                }
                
                .fullScreenCover(isPresented: $transferModal) {
                    TransferModal(transferModal: $transferModal)
                }
                .alert("to Trash ?", isPresented: $dustAlert){
                    Button(role: .cancel, action: {}, label: {Text("cancel")})
                    Button(role: .none, action: {doMultipleDust(selectedItems: selectedItemsManager.selectedItems)}, label: {Text("Trash")})
                    
                } message: {
                    Text("Not deleted from Device")
                }
                
            }
        }
    }

    var notDustArray: [Item] {
    let notDustArray = items.filter { !$0.isDust }
            if notDustArray.isEmpty {
                return []
            }
            return notDustArray
    }
    
    func doMultipleDust(selectedItems: Set<Item>) {
            selectedItemsManager.selectedItems.forEach { item in
            item.isDust.toggle()
                try? viewContext.save()
                selectedItemsManager.selectedItems = []
            }
        }
    
    func doMultipleDelete(selectedItems: Set<Item>) {
        selectedItemsManager.selectedItems.forEach { item in
            viewContext.delete(item)
            try? viewContext.save()
            selectedItemsManager.selectedItems = []
        }
    }

    func doMultipleCheck(selectedItems: Set<Item>) {
        selectedItemsManager.selectedItems.forEach { item in
        item.isCheck.toggle()
            try? viewContext.save()
            selectedItemsManager.selectedItems = []
        }
    }
    
    func doMultipleLike(selectedItems: Set<Item>) {
        selectedItemsManager.selectedItems.forEach { item in
        item.isLiked.toggle()
            try? viewContext.save()
            selectedItemsManager.selectedItems = []
        }
    }
    
    func toggleSelection(item: Item) {
        if selectedItemsManager.selectedItems.contains(item) {
            selectedItemsManager.selectedItems.remove(item)
            } else {
            selectedItemsManager.selectedItems.insert(item)
            }
        }
    
    func onCheck(item: Item) {
            if let index = items.firstIndex(of: item){
                selectedItemsManager.selectedItems.insert(items[index])
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
    
    //
    
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
            let isNotCheckPredicate = NSPredicate(format: "isCheck != true")
            predicates.append(isNotCheckPredicate)
        } else {
            if let index = predicates.firstIndex(where: { $0.predicateFormat.contains("isCheck != true") }) {
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
    
    //
    
    func makeFolder() {
    let newFolder = Folder(context: viewContext)
    newFolder.folderName = textFieldText
    newFolder.folderMadeTime = Date()
    try? viewContext.save()
    textFieldText = ""
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
        selectedItemsManager.selectedItems.contains(item)
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
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
