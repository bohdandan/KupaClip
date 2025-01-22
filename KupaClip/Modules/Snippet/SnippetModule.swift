//
//  SnippetModule.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 22/01/2025.
//

struct SnipetModule: Module {
    static let NAME = "Snippet"
    let name = NAME
    let moduleDetails: ModuleDetails
    let storage: ModuleStorage
    let actionHandler: ModuleActionHandler
    
    init(_ appContext: AppContext) {
        moduleDetails = ModuleDetails(iconSystemName: "text.redaction", color: .green)
        storage = SnippetStorage()
        actionHandler = ClipboardActionHandler()
        
        appContext.set(self)
    }
}
