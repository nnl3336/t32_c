//
//  ColorCircle.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/02/22.
//

import SwiftUI

struct ColorCircle: View {
    
    var color: Color
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack{
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                
           if !isSelected {
             Circle()
              .foregroundColor(Color.black)
              .frame(width: 30, height: 30)
              .opacity(0.3)
              }
                    
                    if isSelected {
                        Circle()
                            .stroke(Color.black, lineWidth: 4)
                            .frame(width: 30, height: 30)
                        
                        Text("✓")
                            .foregroundColor(.white)
                            .frame(width: 5, height: 5)
                            .cornerRadius(8)
                            .background(Color.blue)
                    }
            
                }
        }
    }
