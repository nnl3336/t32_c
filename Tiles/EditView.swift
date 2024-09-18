//
//  EditView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/02/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var makeDate = Date()
    @State var textEditorText = ""
    @State var isSelected1 = false
    @State var isSelected2 = false
    @State var isSelected3 = false
    @State var isSelected4 = false
    @State var isSelected5 = false
    @State var editDate = Date()
    @State private var sisCheck = false
    @State private var sisLiked = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State var dumpAlart = false
    @State var deleteAlart = false
    
    @EnvironmentObject var settingProfile: SettingProfile

    @EnvironmentObject var fsClass: FSClass

    @EnvironmentObject var fwClass: FWClass

    @EnvironmentObject var accentColorClass: AccentColorClass
    
    @EnvironmentObject var messageCopyBallon: MessageCopyBalloon
    
    var item: Item

    init(item: Item) {
        self.item = item
        _textEditorText = State(initialValue: item.text ?? "a")
        _makeDate = State(initialValue: item.makeDate ?? Date())
        _isSelected1 = State(initialValue: item.isRed)
        _isSelected2 = State(initialValue: item.isBlue)
        _isSelected3 = State(initialValue: item.isYellow)
        _isSelected4 = State(initialValue: item.isGreen)
        _isSelected5 = State(initialValue: item.isPink)
        _sisCheck = State(initialValue: item.isCheck)
        _sisLiked = State(initialValue: item.isLiked)
    }
    
    var body: some View {
            NavigationStack {
                ZStack {
                    TextEditor(text: $textEditorText)
                        .background(settingProfile.backColor)
                        .foregroundColor(settingProfile.textColor)
                        .fontWeight(fwClass.fw)
                        .font(fsClass.fs)
                        .onChange(of: textEditorText) { newValue in
                            updateItem(item: item)
                        }
                        .textInputAutocapitalization(.never)
                        .onDisappear(perform: { edit(newItem: item) })
                        .alert("to Trash ?", isPresented: $deleteAlart){
                            Button(role: .cancel, action: {}, label: {Text("cancel")})
                            Button(role: .destructive, action: {doDust(item: item)}, label: {Text("Trash")})
                            
                        } message: {
                            Text("")
                        }
                        .toolbar{
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                HStack {
                                    ColorCircle(color: .red, isSelected: $isSelected1).onTapGesture(perform: { fisSelected1() })
                                    ColorCircle(color: .blue, isSelected: $isSelected2).onTapGesture(perform: { fisSelected2() })
                                    ColorCircle(color: .yellow, isSelected: $isSelected3).onTapGesture(perform: { fisSelected3() })
                                    ColorCircle(color: .green, isSelected: $isSelected4).onTapGesture(perform: { fisSelected4() })
                                    ColorCircle(color: .pink, isSelected: $isSelected5).onTapGesture(perform: { fisSelected5() })
                                    Button(action: { newPost(newItem: item) }) {
                                        Image(systemName: "square.and.pencil")
                                    }
                                }
                            }
                            ToolbarItemGroup(placement: .bottomBar) {
                                HStack{
                                    VStack{
                                        Text("Date: \(makeDate, formatter: itemFormatter1)")
                                        Text("\(makeDate, formatter: itemFormatter2)")
                                    }
                                }
                            }
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button(action: {self.sisCheck.toggle()}) {Image(systemName: sisCheck ? "pencil.circle.fill" : "pencil.circle")}
                                Button(action: {self.sisLiked.toggle()}) {Image(systemName: sisLiked ? "heart.fill" : "heart")}
                                Button(action: {self.deleteAlart.toggle()}) {Image(systemName: "trash")}
                                Button(action: {copy()}) {Image(systemName: "doc.on.doc")}.disabled(messageCopyBallon.isCopyPreview)
                                
                            }
                        }
                        .background(colorForItem())
                        .scrollContentBackground(.hidden)
                    if (messageCopyBallon.isCopyPreview){
                        Text("copied")
                            .modifier(CopyBallonModifier())
                    }
                }
            }
        }
    
    func doDust(item: Item) {
            item.isDust.toggle()
            try? viewContext.save()
            self.presentationMode.wrappedValue.dismiss()
        }
    
    func colorForItem() -> Color {
        if isSelected1 {
            return .red
        } else if isSelected2 {
            return .cyan
        } else if isSelected3 {
            return .yellow
        } else if isSelected4 {
            return .green
        } else if isSelected5 {
            return .pink
        } else {
            return .white
        }
    }
    
    func copy() {UIPasteboard.general.string = textEditorText
            messageCopyBallon.isCopyPreview = true
            messageCopyBallon.vanishCopyMessage()
        }
    
    func edit(newItem: Item) {
        newItem.text = textEditorText
        newItem.makeDate = makeDate
        newItem.editDate = Date()
        newItem.isRed = isSelected1
        newItem.isBlue = isSelected2
        newItem.isYellow = isSelected3
        newItem.isGreen = isSelected4
        newItem.isPink = isSelected5
        newItem.isCheck = sisCheck
        newItem.isLiked = sisLiked
            try? viewContext.save()
        
    }
        
        func newPost(newItem: Item) {
            newItem.text = textEditorText
            newItem.makeDate = makeDate
            newItem.editDate = Date()
            newItem.isRed = isSelected1
            newItem.isBlue = isSelected2
            newItem.isYellow = isSelected3
            newItem.isGreen = isSelected4
            newItem.isPink = isSelected5
            newItem.isCheck = sisCheck
            newItem.isLiked = sisLiked
            try? viewContext.save()
            textEditorText = ""
            makeDate = Date()
            editDate = Date()
            textEditorText = ""
            makeDate = Date()
            isSelected1 = false
            isSelected2 = false
            isSelected3 = false
            isSelected4 = false
            isSelected5 = false
            sisCheck = false
            sisLiked = false
        }
    
    func updateItem(item: Item) {
            item.text = textEditorText
            try? viewContext.save()
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
        
    func fisSelected1() {
        self.isSelected1.toggle()
        self.isSelected2 = false
        self.isSelected3 = false
        self.isSelected4 = false
        self.isSelected5 = false
    }
    
    func fisSelected2() {
        self.isSelected1 = false
        self.isSelected2.toggle()
        self.isSelected3 = false
        self.isSelected4 = false
        self.isSelected5 = false
    }
    
    func fisSelected3() {
        self.isSelected1 = false
        self.isSelected2 = false
        self.isSelected3.toggle()
        self.isSelected4 = false
        self.isSelected5 = false
    }
    
    func fisSelected4() {
        self.isSelected1 = false
        self.isSelected2 = false
        self.isSelected3 = false
        self.isSelected4.toggle()
        self.isSelected5 = false
    }
    
    func fisSelected5() {
        self.isSelected1 = false
        self.isSelected2 = false
        self.isSelected3 = false
        self.isSelected4 = false
        self.isSelected5.toggle()
    }
        
    }
