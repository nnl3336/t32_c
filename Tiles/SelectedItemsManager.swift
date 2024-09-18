//
//  SelectedItemsManager.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/07.
//

import Foundation

class SelectedItemsManager: ObservableObject {
    @Published var selectedItems: Set<Item> = [] {
            didSet {
                isEditing = selectedItems.isEmpty ? false : true
            }
        }
        
    @Published var isEditing: Bool = false
    
    @Published var currentLocation: (x: Int, y: Int) = (-1, -1)

}
