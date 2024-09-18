//
//  MainView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/03.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.makeDate, ascending: true)], animation: .default) private var tiles: FetchedResults<Item>
    
    @State private var offset: CGFloat = 0
    @State private var slideViewShown = false
    
    @State var sheetAddView = false
    @State var sheetEditView = false
    
    @State var isEditing = false
    
    @State var selectedItems: Set<Item> = []
    
    @State var settingView = false
    @EnvironmentObject var settingProfile: SettingProfile
    
    @State var slideView = false
    
    @State var textFieldText = ""
    @State var folderMakeAlart = false
    
    @StateObject var selectedItemsManager = SelectedItemsManager()
    
    @EnvironmentObject var fsClass: FSClass
    
    @EnvironmentObject var fwClass: FWClass

    @EnvironmentObject var otherObserved: OtherObserved
    
    @EnvironmentObject var accentColorClass: AccentColorClass
    
    @State var navigationLinkIsActive = false
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView {
                ZStack {
                    // SlideViewを下に配置
                    SlideView()
                        .zIndex(-1)
                        .frame(width: geometry.size.width * 1/2.5)
                        .offset(x: -UIScreen.main.bounds.width * 1/3.5)
                    
                    if settingProfile.isTile {
                        // ContentViewを横にずらすoffsetを追加
                        MaintView()
                            .offset(x: otherObserved.slideView ? UIScreen.main.bounds.width * 1/2.5 : 0)
                            .animation(.default) // アニメーションを追加することも可能です
                        
                    } else {
                        ListModeView()
                            .offset(x: otherObserved.slideView ? UIScreen.main.bounds.width * 1/2.5 : 0)
                            .animation(.default) // アニメーションを追加することも可能です
                    }
                    
                    if otherObserved.slideView {
                        Rectangle()
                            .foregroundColor(.black.opacity(0.7))
                            .onTapGesture(perform: {
                                otherObserved.slideView.toggle()
                            })
                            .offset(x: otherObserved.slideView ? UIScreen.main.bounds.width * 1/2.5 : 0)
                    }
                    NavigationLink(
                        destination: AddView(showModal: $sheetAddView),
                        isActive: $navigationLinkIsActive
                    ) {
                        EmptyView() // ラベルを空にする
                    }
                    
                }
                .navigationBarTitle("") // NavigationViewのタイトルを空にする
                .toolbarBackground(settingProfile.backColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {settingView.toggle()}) {Image(systemName: "gearshape")}
                        if selectedItemsManager.isEditing {
                            Button(action: {
                                selectedItemsManager.isEditing.toggle()
                                selectedItemsManager.selectedItems = []
                            }) {
                                Text("cancel")
                            }
                        }
                        Button(action: {
                            if settingProfile.isTile {
                                self.sheetAddView.toggle()
                            } else {
                                self.navigationLinkIsActive = true
                            }
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            otherObserved.slideView.toggle()
                            self.offset = slideView ? UIScreen.main.bounds.width * 1/3 : 0
                            selectedItemsManager.selectedItems = []
                        }) {Image(systemName: "sidebar.leading")}
                    }
                }
                .sheet(isPresented: $sheetAddView) {
                    AddView( showModal: $sheetAddView)
                        .presentationDetents([
                            .fraction(0.95)
                        ])
                }
                .sheet(isPresented: $settingView) {
                    SettingView(settingView: $settingView)
                        .presentationDetents([
                            .fraction(0.95)
                        ])
                }
            }
            .accentColor(accentColorClass.ac)

        }
    }
    
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
