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
    var items: [String]
    
    private(set) var filteredItems: [PopupListItem] = []
    private var selectedItemId: UUID?
    
    convenience init() {
        self.init (nil)
    }
    
    init(_ items: [String]?) {
        self.items = items ?? []
        updateFilteredItems()
    }
    
    func updateFilteredItems(query:  String = "") {
        filteredItems = items
            .filter { query.isEmpty || $0.localizedCaseInsensitiveContains(query) }
            .enumerated().map { index, title in
                let shortcut = index < 9 ? index + 1 : nil
                return PopupListItem(title: title, shortcut: shortcut)
            }
        selectNext()
    }
    
    var selectedItem: PopupListItem? {
        get {
            guard let selectedItemId = selectedItemId else { return nil }
            return filteredItems.first { $0.id == selectedItemId }
        }
        set {
            selectedItemId = newValue?.id
        }
    }
    
    func selectNext() {
       guard let currentIndex = selectedItem.flatMap({ filteredItems.firstIndex(of: $0) }) else {
           selectedItemId = filteredItems.first?.id
           return
       }
       let nextIndex = (currentIndex + 1) % filteredItems.count
       selectedItemId = filteredItems[nextIndex].id
   }
   
   func selectPrevious() {
       guard let currentIndex = selectedItem.flatMap({ filteredItems.firstIndex(of: $0) }) else {
           selectedItemId = filteredItems.last?.id
           return
       }
       let previousIndex = (currentIndex - 1 + filteredItems.count) % filteredItems.count
       selectedItemId = filteredItems[previousIndex].id
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
