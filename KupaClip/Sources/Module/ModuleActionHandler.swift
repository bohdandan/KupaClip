//
//  ModuleActionHandler.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//
import Foundation

protocol ModuleActionHandler {
    @discardableResult
    func actionOn(on: UUID) -> Bool
}
