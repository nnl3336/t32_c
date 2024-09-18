//
//  SelectedItemsManager.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/06.
//

import Foundation

class SelectedItemsManager: ObservableObject {
    @Published var selectedItems: Set<Item> = []
}
