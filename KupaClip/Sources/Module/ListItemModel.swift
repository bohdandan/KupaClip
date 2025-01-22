//
//  ListItemModel.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 22/01/2025.
//
import Foundation

class ListItemModel: Identifiable, Hashable {
    let id: UUID
    let title: String

    init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
    
    static func == (lhs: ListItemModel, rhs: ListItemModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
