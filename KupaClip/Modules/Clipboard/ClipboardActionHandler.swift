//
//  ClipboardActionHandler.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//

struct ClipboardActionHandler: ModuleActionHandler {
    func actionOn(on: String) -> Bool {
        AppContext.shared.get(ClipboardService.self).writeToClipboard(on)
        AppContext.shared.get(PasteService.self).pasteToActiveApp()
        return true
    }
}
