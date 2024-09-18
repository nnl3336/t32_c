//
//  SortFolderEnum.swift
//  Tiles
//
//  Created by Yuki Sasaki on 2024/03/14.
//

import SwiftUI

enum SortFolderEnum: String, CaseIterable {
    
    case byMakeDate
    case byFolderName
    case byCurrentAddDate
    
    var sF: [SortDescriptor<Folder>] {
        switch self {
        case .byMakeDate:
            return [SortDescriptor<Folder>(\.folderMadeTime, order: .forward)]
        case .byFolderName:
            return [SortDescriptor<Folder>(\.folderName, order: .forward)]
        case .byCurrentAddDate:
            return [SortDescriptor<Folder>(\.currentDate, order: .forward)]
        }
    }

    var sFString: String{
        switch self {
        case .byMakeDate:
            return "by MakeDate"
        case .byFolderName:
            return "by FolderName"
        case .byCurrentAddDate:
            return "by CurrentAddedDate"
        }
    }

    
}

