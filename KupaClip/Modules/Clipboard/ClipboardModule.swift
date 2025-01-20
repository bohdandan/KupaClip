//
//  ClipboardModule.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//

struct ClipboardModule: Module {
    
    let name = "Clipboard"

    private let clipboardStorage: ClipboardStorage
    private let clipboardActionHandler: ClipboardActionHandler
    
    init() {
        clipboardStorage = ClipboardStorage(maxLimit: 10)
        clipboardActionHandler = ClipboardActionHandler()
    }
    
    func initialise(_ appContext: AppContext) {
        appContext.set(clipboardStorage)
        appContext.set(clipboardActionHandler)
        appContext.set(ClipboardService(storage: clipboardStorage))
    }
    
    func getModuleDetails() -> ModuleDetails {
        return ModuleDetails(iconSystemName: "clipboard", color: .orange)
    }

    func getStorage() -> any ModuleStorage {
        return clipboardStorage
    }
    
    func getActionHandler() -> any ModuleActionHandler {
        return clipboardActionHandler
    }
    
    static func == (lhs: ClipboardModule, rhs: ClipboardModule) -> Bool {
        lhs.name == rhs.name
    }
}
