//
//  PopupListViewModel.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 25/12/2024.
//
import SwiftUI

@Observable
class PopupListViewModel {
    var items: [PopupListItem]
    private var selectedIndex: Int?
    
    init(items: [String]) {
        self.items = items.enumerated().map { index, title in
            let shortcut = index < 9 ? index + 1 : nil
            return PopupListItem(title: title, shortcut: shortcut)
        }
        self.selectedIndex = items.isEmpty ? nil : 0
    }
    
    var selectedItem: PopupListItem? {
        get {
            guard let index = selectedIndex else { return nil }
            return items[index]
        }
        set {
            if let newValue = newValue, let index = items.firstIndex(of: newValue) {
                selectedIndex = index
            }
        }
    }
    
    func selectNext() {
        guard let currentIndex = selectedIndex else { return }
        selectedIndex = (currentIndex + 1) % items.count
    }
    
    func selectPrevious() {
        guard let currentIndex = selectedIndex else { return }
        selectedIndex = (currentIndex - 1 + items.count) % items.count
    }
    
    func isSelected(item: PopupListItem) -> Bool {
        guard let index = selectedIndex else { return false }
        return items[index].id == item.id
    }
}

@Observable
class PopupListItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var shortcut: Int?

    init(title: String, shortcut: Int?) {
        self.title = title
        self.shortcut = shortcut
    }
    
    static func == (lhs: PopupListItem, rhs: PopupListItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
