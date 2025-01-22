//
//  SnippetStorage.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 06/01/2025.
//

import Foundation

final class SnippetStorage: ModuleStorage {
    
    func getFilteredListOfItems(query: String) -> [ListItemModel] {
        return DummyData.snippets.map{ListItemModel(id: UUID(), title: $0)}
    }
}
