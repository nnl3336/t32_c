//
//  ItemView.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/02/22.
//

import SwiftUI

struct ItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default) private var items: FetchedResults<Item>
    @Binding var editViewSheet: Bool
    @State var makeDate = Date()

    @EnvironmentObject var settingProfile: SettingProfile
    
    var item: Item

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .border(.black)
                    .foregroundColor(colorForItem(item))
                VStack {
                    Text(item.text ?? "a")
                        .offset(x: -geometry.size.width * 0.1, y: -geometry.size.height * 0.1)
                        .padding()
                        .font(.caption)
                    HStack{
                        if item.isLiked {
                            Image(systemName: "heart.fill")
                        } else {
                        }
                        if item.isCheck {
                            Image(systemName: "pencil.circle.fill")
                        } else {
                        }
                        Text("\(item.folder?.folderName ?? "")")
                            .font(.caption)
                    }
                    if settingProfile.isTime {
                        Text("\(item.makeDate ?? Date(), formatter: itemFormatter1)")
                            .frame(width: geometry.size.width * 0.9)
                            .font(.caption)
                    }
                }
            }
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

    
}
