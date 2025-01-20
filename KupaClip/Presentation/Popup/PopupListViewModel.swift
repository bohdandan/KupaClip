//
//  PopupListViewModel.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 25/12/2024.
//
import SwiftUI
import Combine

@Observable
class PopupListViewModel {
    private(set) var items: [PopupListItem] = []
    private var selectedItemId: UUID?
    
    func setItems(_ items: [String]) {
        self.items = items
            .enumerated()
            .map { index, title in
                let shortcut = index < 9 ? index + 1 : nil
                return PopupListItem(title: title, shortcut: shortcut)
            }
        selectNext()
    }

    var selectedItem: PopupListItem? {
        get {
            return items.first { $0.id == selectedItemId }
        }
        set {
            selectedItemId = newValue?.id
        }
    }
    
    func selectNext() {
       guard let currentIndex = selectedItem.flatMap({ items.firstIndex(of: $0) }) else {
           selectedItemId = items.first?.id
           return
       }
       let nextIndex = (currentIndex + 1) % items.count
       selectedItemId = items[nextIndex].id
   }
   
   func selectPrevious() {
       guard let currentIndex = selectedItem.flatMap({ items.firstIndex(of: $0) }) else {
           selectedItemId = items.last?.id
           return
       }
       let previousIndex = (currentIndex - 1 + items.count) % items.count
       selectedItemId = items[previousIndex].id
   }
    
    func isSelected(item: PopupListItem) -> Bool {
        return selectedItemId == item.id
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
