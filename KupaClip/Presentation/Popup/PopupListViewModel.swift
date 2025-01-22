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
    private(set) var items: [ListItemModel] = []
    private var selectedItemId: UUID?
    
    func setItems(_ items: [ListItemModel]) {
        self.items = items.map{ListItemModel(id: $0.id, title: $0.title)}
        selectNext()
    }

    var selectedItem: ListItemModel? {
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
    
    func isSelected(item: ListItemModel) -> Bool {
        return selectedItemId == item.id
    }
}
