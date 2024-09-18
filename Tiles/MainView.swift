//
//  ContentView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/02/22.
//

import SwiftUI
import CoreData

struct MainView: View {
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
    
    @State var selectedTabIndex = 0
    
    @State var settingView = false
    @ObservedObject var settingProfile = SettingProfile()
    
    @State var slideView = false
    
    @State private var offset = CGFloat.zero
    @State private var closeOffset = CGFloat.zero
    @State private var offset1 = CGFloat.zero
    
    @State var textFieldText = ""
    @State var folderMakeAlart = false

    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                
            SlideView()
            .frame(width: geometry.size.width * 1/3 )
            .offset(x: geometry.size.width * 1/3)
                
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
                    
                    
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(items, id: \.self) { item in
                                ZStack {
                                    ItemView(item: item, editViewSheet: $editViewSheet)
                                        .onTapGesture {
                                            if isEditing {
                                                self.toggleSelection(item: item)
                                            } else {
                                                self.editViewSheet.toggle()
                                                if let index = items.firstIndex(of: item){
                                                    selectedTabIndex = index
                                                }
                                            }
                                        }
                                        .sheet(isPresented: $editViewSheet) {
                                            EditView(selectedTabIndex: $selectedTabIndex, item: item)
                                                .presentationDetents([
                                                    .fraction(0.95)
                                                ])
                                        }
                                        .frame(width: geometry.size.width * 1/5, height: geometry.size.height * 1/10)
                                        .contextMenu{
                                            if selectedItems.isEmpty {
                                                Button(action: {
                                                    isEditing.toggle()
                                                    onCheck(item: item)
                                                }) {
                                                    Text("Select")
                                                }
                                                Button(role: .none, action: {doLike(item: item)}) {Text("Like")}
                                                Button(role: .none, action: {doCheck(item: item)}) {Text("Check")}
                                                Button(role: .destructive, action: {doDelete(item: item)}) {Text("Delete")}
                                            } else {
                                                Button(role: .destructive, action: {doMultipleDelete(selectedItems: selectedItems)}) {Text("Delete")}
                                            }
                                        }
                                    if isSelected(item: item) {
                                        ZStack {
                                            Rectangle()
                                                .frame(width: geometry.size.width * 1/5, height: geometry.size.height * 1/10)
                                                .foregroundStyle(.black.opacity(0.4))
                                            Image(systemName: "checkmark.circle.fill")
                                        }.onTapGesture(perform: {toggleSelection(item: item)})
                                            .contextMenu{
                                                if !selectedItems.isEmpty {
                                                    Button(action: {doMultipleCheck(selectedItems: selectedItems)}) {Text("Check")}
                                                    Button(action: {doMultipleLike(selectedItems: selectedItems)}) {Text("Like")}
                                                    Button(role: .destructive, action: {doMultipleDelete(selectedItems: selectedItems)}) {Text("Delete")}
                                                }
                                            }
                                    } else {
                                    }
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                }
                
                }
                .navigationTitle("")
                .sheet(isPresented: $sheetAddView) {
                    AddView(showModal: $sheetAddView)
                        .presentationDetents([
                            .fraction(0.95)
                        ])
                }
                .sheet(isPresented: $sheetAddView) {
                    SettingView(showModal: $settingView, settingProfile: settingProfile)
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
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .onChange(of: searchText) { newValue in
                search(text: searchText, isRed: sisRed, isBlue: isBlue, isYellow: sisYellow, isGreen: sisGreen, isPink: sisPink, isCheck: sisCheck, isLiked: sisLiked)
            }
            .onChange(of: [sisRed, sisBlue, sisYellow, sisGreen, sisPink, sisCheck, sisLiked]) { newValue in
                search(text: searchText, isRed: sisRed, isBlue: isBlue, isYellow: sisYellow, isGreen: sisGreen, isPink: sisPink, isCheck: sisCheck, isLiked: sisLiked)
            }
            .alert("make Folder ?", isPresented: $folderMakeAlart){
                TextField("テキスト", text: $textFieldText)
                Button(role: .cancel, action: {self.folderMakeAlart.toggle()}, label: {Text("cancel")})
                Button(role: .none, action: {makeFolder()}, label: {Text("Make")})
                
            } message: {
                Text("")
            }
            
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
    
    func onCheck(item: Item) {
            if let index = items.firstIndex(of: item){
    selectedItems.insert(items[index])
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
    
    func makeFolder() {
    let newFolder = Folder(context: viewContext)
    newFolder.folderName = textFieldText
    newFolder.folderMadeTime = Date()
    try? viewContext.save()
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
    MainView()
}
