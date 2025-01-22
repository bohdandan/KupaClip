//
//  PopupManager.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 11/01/2025.
//
import SwiftUI
import KeyboardShortcuts
import Combine

extension KeyboardShortcuts.Name {
    static let openClipboard = Self("openClipboard", default: .init(.zero, modifiers: [.command, .shift]))
    static let openSnippets = Self("openSnippets")
    static let openTools = Self("openTools")
}

final class FloatingPanelManager {
    private var contentWindow: NSWindow?
    
    init() {
        setupPopupHotkey()
    }
    
    private func setupPopupHotkey() {
        let keys: [(KeyboardShortcuts.Name, String)] = [
                (.openClipboard, ClipboardModule.NAME),
                (.openSnippets, SnipetModule.NAME),
                (.openTools, ToolModule.NAME)]
        
        keys.forEach { shortcut, name in
            KeyboardShortcuts.onKeyUp(for: shortcut) { [self] in
                if (contentWindow == nil) {
                    AppContext.shared.get(PopupState.self).activeModuleName = name
                    open()
                    return
                }
                if (AppContext.shared.get(PopupState.self).activeModuleName == name) {
                    close()
                    return
                }
                AppContext.shared.get(PopupState.self).activeModuleName = name
            }
        }
    }
    
    private func open() {
        Log.clipboard.info("Showing content window \(self.contentWindow)")
        self.close()
        
        let contentPanel = ContentPanel(nestedView: Popup())
        
        contentWindow = contentPanel
    
        contentPanel.makeKeyAndOrderFront(nil)
        contentPanel.makeKey()
    }
    
    func close() {
        if let window = contentWindow {
            window.close()
            contentWindow = nil
        }
    }
}
