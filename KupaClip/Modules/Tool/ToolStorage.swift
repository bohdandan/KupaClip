//
//  ToolStorage.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 06/01/2025.
//
import Foundation

final class ToolStorage: ModuleStorage {
    
    func getFilteredListOfItems(query: String) -> [ListItemModel] {
        return DummyData.tools.map{ListItemModel(id: UUID(), title: $0)}
    }
}
