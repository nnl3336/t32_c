//
//  FolderArrayView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/05.
//

import SwiftUI

struct FolderArrayView: View {

@Environment(\.managedObjectContext) private var viewContext
@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default) private var items: FetchedResults<Item>
@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ Folder.folderMadeTime, ascending: true)], animation: .default) private var  folders: FetchedResults<Folder>
    @Environment(\.dismiss) var dismiss
    
    var folder: Folder
    
    @State var searchText: String = ""
    @State var isEditMode: EditMode = .inactive
    @State var transferModal = false
    @State var dustAlert = false
    @State var selectionValue: Set<Item> = []

    var body: some View {
        
        NavigationView {
            
            List(selection: $selectionValue){
                Section(header: Text("")){
                    ForEach(folderItems){folderItem in
                        NavigationLink(destination: FolderArrayView(folder: folder), label: {Text(folderItem.text ?? "a")})
                    }
                        .fixedSize(horizontal: false, vertical: true)
                    
                }.foregroundColor(.black)
                    .listRowBackground(
                        Rectangle()
                            .background(.clear)
                            .foregroundColor(.white)
                            .opacity(0.3)
                    )
                    
                
            }
            .navigationTitle(folder.folderName ?? "a").navigationBarTitleDisplayMode(.inline) .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "search")
                .onChange(of: searchText) { newValue in
                    search(text: newValue)
                }
            
            .environment(\.editMode, $isEditMode)
                .gesture(longPressGesture)
                
                .scrollContentBackground(.hidden)
                .background(.white)
            
                .toolbar{
                    
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        if isEditMode == .active{
                        Button(action: {self.dustAlert.toggle()}) {Text("dust")}
                        Button(action: {self.transferModal.toggle()}) {Text("transfer")}
                        Button(action: {self.isEditMode = .inactive}) {Text("cancel")}
                        }
                        
                        NavigationLink(destination: FolderPostView(folder: folder), label: {Image(systemName: "person")})
                        
                    }
                    
                    
                }.fullScreenCover(isPresented: $transferModal) {
                    TransferModal(selectionValue: selectionValue, transferModal: $transferModal, folder: folder)
                    }
                
                .alert("Dust?", isPresented: $dustAlert){
                    Text("デバイスからは削除されません")
                    Button(role: .cancel, action: {}, label: {Text("cancel")})
                    Button(role: .destructive, action: {itemsDust(selectionValue: selectionValue)}, label: {Text("Dust")})
                    }
            
                }
                
            }

    
    func search(text: String) {
            if text.isEmpty {

                items.nsPredicate = nil
            } else {
                items.nsPredicate = NSPredicate(format: "folderName contains[c] %@", text)
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

     var folderItems: [Item] {
             if let folderItems = folder.item?.allObjects as? [Item] {
                 return folderItems
             }
         return [] // デフォルトの空の配列を返す
    }
    

}

