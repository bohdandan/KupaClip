//
//  ClipboardModule.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//

import Defaults

struct ClipboardModule: Module {
    static let NAME = "Clipboard"
    let name = NAME
    let moduleDetails: ModuleDetails
    let storage: ModuleStorage
    let actionHandler: ModuleActionHandler
    
    init(_ appContext: AppContext) {
        moduleDetails = ModuleDetails(iconSystemName: "clipboard", color: .orange)
        storage = ClipboardStorage(maxLimit: Defaults[.clipboardStorageSize])
        actionHandler = ClipboardActionHandler()
        
        appContext.set(storage)
        appContext.set(actionHandler)
        appContext.set(ClipboardService(storage: storage as! ClipboardStorage))
        appContext.set(self)
    }
}
