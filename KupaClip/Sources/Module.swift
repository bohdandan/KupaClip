//
//  Module.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//

protocol Module {
    
    var name: String { get }
        
    func initialise(_ appContext: AppContext)
    func getModuleDetails() -> ModuleDetails
    func getStorage() -> ModuleStorage
    func getActionHandler() -> ModuleActionHandler
}
