//
//  ListModeCell.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/15.
//

import SwiftUI

struct ListModeCell: View {
    
    var item: Item
    
    @EnvironmentObject var settingProfile: SettingProfile
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack{
                Text(item.text ?? "a")
                
                HStack{
                    Text("\(item.folder?.folderName ?? "a")")

                    HStack{
                        
                        if item.isRed {
                        Circle()
                                        .fill(.red)
                                        .frame(width: 5, height: 5)
                        } else {
                        }

                        if item.isBlue {
                        Circle()
                                        .fill(.blue)
                                        .frame(width: 5, height: 5)
                        } else {
                        }

                        if item.isYellow {
                        Circle()
                                        .fill(.yellow)
                                        .frame(width: 5, height: 5)
                        } else {
                        }

                        if item.isGreen {
                        Circle()
                                        .fill(.green)
                                        .frame(width: 5, height: 5)
                        } else {
                        }

                        if item.isPink {
                        Circle()
                                        .fill(.pink)
                                        .frame(width: 5, height: 5)
                        } else {
                        }

                    }
                    
                }
                
                if settingProfile.isTime {
                    Text("\(item.makeDate ?? Date(), formatter: itemFormatter1)")
                        .frame(width: geometry.size.width * 0.9)
                        .font(.caption)
                }
                
            }
            
        }
        
    }
        
        // func
        
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
        
    }


