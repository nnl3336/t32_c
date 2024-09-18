//
//  AddView2.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/07.
//

import SwiftUI

struct AddView2: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var makeDate = Date()
    @State var editDate = Date()
    @State var textEditorText = ""
    @State var isSelected1 = false
    @State var isSelected2 = false
    @State var isSelected3 = false
    @State var isSelected4 = false
    @State var isSelected5 = false
    @State private var sisCheck = false
    @State private var sisLiked = false
    
    @State var item: Item?
    
    @Environment(\.presentationMode) var presentationMode
    @State var deleteAlert = false
    
    var body: some View {
        NavigationStack{
            TextEditor(text: $textEditorText).textInputAutocapitalization(.never)
                .onChange(of: textEditorText) { newValue in
                    if let unwrappedItem = item {
                        updateItem(item: unwrappedItem)
                    }
                }
                .alert("Delete Item?", isPresented: $deleteAlert) {
                    if let unwrappedItem = item {
                        Button(role: .cancel) {
                            // Cancel action
                        } label: {
                            Text("Cancel")
                        }
                        Button(role: .destructive) {
                            doDust(item: unwrappedItem)
                        } label: {
                            Text("Trash")
                        }
                    }
                }

                .onDisappear(perform: {add()})
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            ColorCircle(color: .red, isSelected: $isSelected1).onTapGesture(perform: { fisSelected1() })
                            ColorCircle(color: .blue, isSelected: $isSelected2).onTapGesture(perform: { fisSelected2() })
                            ColorCircle(color: .yellow, isSelected: $isSelected3).onTapGesture(perform: { fisSelected3() })
                            ColorCircle(color: .green, isSelected: $isSelected4).onTapGesture(perform: { fisSelected4() })
                            ColorCircle(color: .pink, isSelected: $isSelected5).onTapGesture(perform: { fisSelected5() })
                            Button(action: { newPost() }) {
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
                        Button(action: {self.showModal = false}) {Image(systemName: "chevron.left")}
                            .foregroundColor(.blue)
                        Button(action: {self.sisCheck.toggle()}) {Image(systemName: sisCheck ? "pencil.circle.fill" : "pencil.circle")}
                        Button(action: {self.sisLiked.toggle()}) {Image(systemName: sisLiked ? "heart.fill" : "heart")
                            Button(action: {self.deleteAlert.toggle()}) {Image(systemName: "trash")}
                            
                        }
                    }
                }
                    .background(colorForItem())
                    .scrollContentBackground(.hidden)
                }
        }
    
    func doDust(item: Item) {
            viewContext.delete(item)
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
    
    func firstAdd() {
            let newItem = Item(context: viewContext)
                newItem.makeDate = makeDate
                try? viewContext.save()
        }
    
    /* func firstAdd() {
            let newItem = Item(context: viewContext)
                try? viewContext.save()
        } */
    
    func add() {
        let newItem = Item(context: viewContext)
        if textEditorText != "" {
            newItem.text = textEditorText
            newItem.makeDate = Date()
            newItem.isRed = isSelected1
            newItem.isBlue = isSelected2
            newItem.isYellow = isSelected3
            newItem.isGreen = isSelected4
            newItem.isPink = isSelected5
            newItem.isCheck = sisCheck
            newItem.isLiked = sisLiked
            try? viewContext.save()
        }
        
    }
        
        func newPost() {
            if textEditorText != "" {
                let newItem = Item(context: viewContext)
                newItem.text = textEditorText
                newItem.makeDate = Date()
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
            }
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
