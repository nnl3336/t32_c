//
//  SlideView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/03.
//

import SwiftUI

struct SlideView: View {

@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ Folder.folderMadeTime, ascending: true)], animation: .default) private var  folders: FetchedResults<Folder>
    
@Environment(\.managedObjectContext) private var viewContext

@State var toFolder = false
    
@State var deleteAlart = false
    
@EnvironmentObject var settingProfile: SettingProfile

@EnvironmentObject var otherObserved: OtherObserved

@EnvironmentObject var fsClass: FSClass

@EnvironmentObject var fwClass: FWClass

@EnvironmentObject var sortFolderClass: SortFolderClass
    
@State var searchText: String = ""
    
@State private var isTexting: Bool = false
    
@State private var textFieldText: String = ""
    
@State var editFolderName = false
    
var body: some View {
    
    GeometryReader { geometry in
        
        VStack {
            Spacer()
            
            Menu {
                // ソート方法を切り替えるMenuItem
                Button(action: {
                    sortFolderClass.sortFolderEnum = .byMakeDate
                    saveSortType(sortFolderClass.sortFolderEnum ?? .byMakeDate)  // ボタンが押されるたびにソート方法を保存
                    folders.sortDescriptors = sortFolderClass.sF

                }) {
                    HStack{
                        Text("By Make Date")
                        if sortFolderClass.sortFolderEnum == .byMakeDate {
                            Spacer()
                            Text("✓")
                        } else {
                            Spacer()
                        }
                    }
                }
                
                Button(action: {
                    sortFolderClass.sortFolderEnum = .byFolderName
                    saveSortType(sortFolderClass.sortFolderEnum ?? .byFolderName)
                    folders.sortDescriptors = sortFolderClass.sF

                }) {
                    HStack{
                        Text("By Folder Name")
                        if sortFolderClass.sortFolderEnum == .byFolderName {
                            Spacer()
                            Text("✓")
                        } else {
                            Spacer()
                        }
                    }
                }
                
                Button(action: {
                    sortFolderClass.sortFolderEnum = .byCurrentAddDate
                    saveSortType(sortFolderClass.sortFolderEnum ?? .byCurrentAddDate)
                    folders.sortDescriptors = sortFolderClass.sF

                }) {
                    HStack{
                        Text("By Open Folders")
                        if sortFolderClass.sortFolderEnum == .byCurrentAddDate {
                            Spacer()
                            Text("✓")
                        } else {
                            Spacer()
                        }
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }

            
            List{
                Section{
                    FolderItem(a: "Memo", b: "folder")
                        .onTapGesture(perform: {otherObserved.slideView.toggle()})
                    
                    ForEach(folders){folder in
                        NavigationLink(destination: FolderArrayView(folder: folder), label: {
                            Text(folder.folderName ?? "a")
                                .alert("edit Folder Name ?", isPresented: $editFolderName){
                                TextField("folder name", text: $textFieldText)
                                Button(role: .cancel, action: {}, label: {Text("cancel")})
                                    Button(role: .none, action: {editFolderName(folder: folder)}, label: {Text("Edit")})
                                
                                } message: {
                                    Text("")
                                }
                                .onLongPressGesture(perform: {
                                editFolderName.toggle()
                                    textFieldText = folder.folderName ?? ""
                                })
                        })
                        .swipeActions {
                            Button(action: {
                                deleteAlart.toggle()
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .alert("delete Folder ?", isPresented: $deleteAlart){
                            Button(role: .cancel, action: {}, label: {Text("cancel")})
                            Button(role: .destructive, action: {doDelete(selectedItems: folder)}, label: {Text("Delete")})
                            
                        } message: {
                            Text("")
                        }
                    }
                    
                    
                    NavigationLink(destination: DustArrayView(), label: {
                        FolderItem(a: "Trash", b: "trash")
                    })
                }
            }
            .toolbar{
                
            }
        }

        .onAppear(perform: {
         folders.sortDescriptors = sortFolderClass.sF
        })
    }

}

// func
    
    func saveSortType(_ sortType: SortFolderEnum) {
        UserDefaults.standard.set(sortType.rawValue, forKey: "isSF")
        print("a")
    }
    
    func editFolderName(folder: Folder) {
    folder.folderName = textFieldText
    try? viewContext.save()
    textFieldText = ""
    }
    
    func doDelete(selectedItems: Folder){
    if let index = folders.firstIndex(of: selectedItems){
    viewContext.delete (folders[index])
    try? viewContext.save()
    }
    }
    
     func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { folders[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}
