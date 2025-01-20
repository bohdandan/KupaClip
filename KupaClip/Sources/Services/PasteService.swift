//
//  PasteService.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 10/01/2025.
//

import AppKit
import Defaults

//Inspired by https://github.com/Clipy/Clipy/blob/develop/Clipy/Sources/Services/PasteService.swift
class PasteService {
    
    func checkAccessibilityEnabled() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options)
    }
    
    func pasteToActiveApp() {
        checkAccessibilityEnabled()
    }
}

