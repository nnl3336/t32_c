//
//  FolderItem.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/03.
//

import SwiftUI

struct FolderItem: View {
    var a = "テキスト"
    var b = "テキスト"
    var body: some View {
        HStack {
            Image(systemName: b)
            Text(a)
            Spacer()
        }
    }
}

