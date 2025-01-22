//
//  ModuleActionHandler.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//

protocol ModuleActionHandler {
    @discardableResult
    func actionOn(on: String) -> Bool
}
