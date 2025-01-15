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
    static let togglePopup = Self("togglePopup", default: .init(.p, modifiers: [.command, .shift]))
}

final class FloatingPanelManager {
    private var contentWindow: NSWindow?
    
    init() {
        setupPopupHotkey()
    }
    
    private func setupPopupHotkey() {
        KeyboardShortcuts.onKeyUp(for: .togglePopup) { [self] in
            if (contentWindow == nil) {
                open()
            } else {
                close()
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
