//
//  ClipboardHistory.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 05/01/2025.
//
import Foundation

final class ClipboardStorage: ModuleStorage {
    
    private(set) var data: [CliboardItem] = []
    
    private let maxLimit: Int
    
    init(maxLimit: Int) {
        self.maxLimit = maxLimit
    }
    
    init(maxLimit: Int, data: [CliboardItem]) {
        self.maxLimit = maxLimit
        self.data = data
    }
    
    func populateData(data: [CliboardItem]) {
        data.forEach {self.data.insert($0, at: 0)}
    }
    
    func getFilteredListOfItems(query: String) -> [ListItemModel] {
        return data
            .filter { query.isEmpty || $0.content.localizedCaseInsensitiveContains(query) }
            .map { ListItemModel(id: $0.id, title: $0.content)}
    }
    
    func getById(id: UUID) -> CliboardItem? {
        return data.first {$0.id == id}
    }
    
    func addToHistory(_ item: CliboardItem) {
        if let index = data.firstIndex(of: item) {
            data[index].timesCopied += 1
            data[index].lastUpdated = item.dateCreated
        } else {
            data.insert(item, at: 0)
        }
        
        if data.count > maxLimit {
            data.removeLast()
        }
    }
    
    func clearHistory() {
        data.removeAll()
    }
}
