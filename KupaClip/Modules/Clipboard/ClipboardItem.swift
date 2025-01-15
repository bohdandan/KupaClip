//
//  ClipboardItem.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 13/01/2025.
//

import Foundation
import AppKit

struct CliboardItem: Equatable, Hashable {
    let types: [NSPasteboard.PasteboardType]
    let content: String
    let appBundleIdentifier: String
    let dateCreated: Date = Date()
    
    var timesCopied: Int = 1
    var lastUpdated: Date = Date()
    
    init(pasteboard: NSPasteboard, appBundleIdentifier: String) {
        self.types = pasteboard.types ?? []
        self.content = pasteboard.string(forType: .string) ?? ""
        self.appBundleIdentifier = appBundleIdentifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }
    
    static func == (lhs: CliboardItem, rhs: CliboardItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
