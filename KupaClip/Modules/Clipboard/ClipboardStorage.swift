//
//  ClipboardHistory.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 05/01/2025.
//
import SwiftUI

@Observable
final class ClipboardStorage: ObservableObject {
    
    private(set) var data: [String] = []
    
    private let maxLimit: Int
    
    init(maxLimit: Int) {
        self.maxLimit = maxLimit
    }
    
    init(maxLimit: Int, data: [String]) {
        self.maxLimit = maxLimit
        self.data = data
    }
    
    func addToHistory(_ item: String) {
        if let existingIndex = data.firstIndex(of: item) {
            data.remove(at: existingIndex)
        }
        
        data.insert(item, at: 0)
        
        if data.count > maxLimit {
            data.removeLast()
        }
    }
    
    func clearHistory() {
        data.removeAll()
    }
}
