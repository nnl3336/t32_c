//
//  TransferModal.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/05.
//

import SwiftUI

struct TransferModal: View {
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ Folder.folderMadeTime, ascending: true)], animation: .default) private var  folders: FetchedResults<Folder>
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText = ""
    @State var selectionValue: Set<Item> = []
    @Binding var transferModal: Bool
    
    @EnvironmentObject var settingProfile: SettingProfile
    
    @EnvironmentObject var selectedItemsManager: SelectedItemsManager
    
    
    
    var body: some View {
        
        GeometryReader{ geometry in
            
            ZStack{
                
                Rectangle()
                    .background(Color.pink)
                    .opacity(0.1)
                    .onTapGesture(perform: {dismiss()})
                
                ZStack{
                    
                    NavigationStack{
                        
                        List {
                            FolderItem(a: "Memo", b: "folder")
                                .contentShape(Rectangle())
                                .onTapGesture(perform: {
                                    transferMemo()
                                })
                            
                            ForEach(folders) { folder in
                                Text(folder.folderName ?? "a")
                                    .onTapGesture(perform: {
                                        transfer(folder: folder)
                                    })
                            }
                            
                            FolderItem(a: "Trash", b: "trash")
                                .contentShape(Rectangle())
                                .onTapGesture(perform: {
                                    doMultipleDust(selectedItems: selectedItemsManager.selectedItems)
                                })
                        }
                    }
                    
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "search")
                    .textInputAutocapitalization(.never)
                    
                    .offset(y: geometry.size.height * 2/50)
                    
                }
                
            }
            
            
        }
        
    }
    
    // func
    
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
    
    func transferMemo() {
        selectedItemsManager.selectedItems.map{$0}.forEach{ value in
            value.folder =  nil
            
            try? viewContext.save()
        }
        transferModal.toggle()
        selectedItemsManager.selectedItems = []
    }
    
    /* func transferDust() {
     selectedItemsManager.selectedItems.map{$0}.forEach{ value in
     value.isDust.toggle()
     
     try? viewContext.save()
     }
     transferModal.toggle()
     selectedItemsManager.selectedItems = []
     } */
    
    func doMultipleDust(selectedItems: Set<Item>) {
            selectedItemsManager.selectedItems.forEach { item in
            item.isDust.toggle()
                try? viewContext.save()
                selectedItemsManager.selectedItems = []
                transferModal.toggle()
            }
        }
     
     
     }
