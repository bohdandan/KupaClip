//
//  ClipboardActionHandler.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 15/01/2025.
//
import Foundation

struct ClipboardActionHandler: ModuleActionHandler {
    func actionOn(on: UUID) -> Bool {
        guard let item = AppContext.shared.get(ClipboardStorage.self).getById(id: on) else { return false}
        AppContext.shared.get(ClipboardService.self).writeToClipboard(item.content)
        AppContext.shared.get(PasteService.self).pasteToActiveApp()
        return true
    }
}
