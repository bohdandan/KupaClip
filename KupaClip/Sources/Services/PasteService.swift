//
//  PasteService.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 10/01/2025.
//

import AppKit
import Defaults
import KeyboardShortcuts

//Inspired by https://github.com/Clipy/Clipy/blob/develop/Clipy/Sources/Services/PasteService.swift
class PasteService {
    
    func checkAccessibilityEnabled() -> Bool {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        return AXIsProcessTrustedWithOptions(options)
    }
    
    func pasteToActiveApp() {
        guard Defaults[.insertIntoActiveApp] else { return }
        if (checkAccessibilityEnabled()) {
            Log.common.debug("Accesability is not enabled")
        }
        
        Task { @MainActor in
            let vKeyCode = UInt16(KeyboardShortcuts.Key.v.rawValue)
            let source = CGEventSource(stateID: .combinedSessionState)
            
            // Disable local keyboard events while pasting
            source?.setLocalEventsFilterDuringSuppressionState([.permitLocalMouseEvents, .permitSystemDefinedEvents],
                                                               state: .eventSuppressionStateSuppressionInterval)
            
            // Press Command + V
            let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: vKeyCode, keyDown: true)
            keyVDown?.flags = .maskCommand
            // Release Command + V
            let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: vKeyCode, keyDown: false)
            keyVUp?.flags = .maskCommand
            // Post Paste Command
            keyVDown?.post(tap: .cgAnnotatedSessionEventTap)
            keyVUp?.post(tap: .cgAnnotatedSessionEventTap)
        }
    }
}

