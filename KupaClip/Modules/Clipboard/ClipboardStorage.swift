//
//  ClipboardHistory.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 05/01/2025.
//

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
    
    func getFilteredListOfItems(query: String) -> [String] {
        return data
            .filter { query.isEmpty || $0.content.localizedCaseInsensitiveContains(query) }
            .map { $0.content }
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
