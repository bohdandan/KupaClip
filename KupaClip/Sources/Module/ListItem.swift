//
//  ListItem.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 22/01/2025.
//
import Foundation

struct ListItem {
    let id: UUID
    let title: String
    
    init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}
