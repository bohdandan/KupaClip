//
//  Module.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//

protocol Module {
    
    var name: String { get }
    var moduleDetails: ModuleDetails { get }
    var storage: ModuleStorage { get }
    var actionHandler: ModuleActionHandler { get }
        
    init(_ appContext: AppContext)
}
