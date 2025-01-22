//
//  ModuleManager.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 22/01/2025.
//
import SwiftUI

@Observable
class ModuleManager {
    var activeModuleName: String
    
    @ObservationIgnored let modules: [Module]
    
    init(_ modules: [Module]) {
        self.modules = modules
        self.activeModuleName = modules.first!.name
    }
}
