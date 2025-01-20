//
//  ModuleStorage.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//

protocol ModuleStorage {
    func getFilteredListOfItems(query: String) -> [String]
}
