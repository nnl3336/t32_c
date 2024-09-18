//
//  SearchBar.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/02/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    @Binding var sisRed: Bool
    @Binding var sisBlue: Bool
    @Binding var sisYellow: Bool
    @Binding var sisGreen: Bool
    @Binding var sisPink: Bool
    @Binding var sisCheck: Bool
    @Binding var sisNotCheck: Bool
    @Binding var sisLiked: Bool

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(.horizontal)
                .textInputAutocapitalization(.never)
                .onTapGesture {
                    isSearching = true
                }

            if isSearching {
                Button(action: {
                    isSearching = false
                    text = ""
                    sisRed = false
                    sisBlue = false
                    sisYellow = false
                    sisGreen = false
                    sisPink = false
                    sisCheck = false
                    sisNotCheck = false
                    sisLiked = false
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .padding(.vertical)
        .background(Color.gray.opacity(0.1))
    }
    
    
        
}
