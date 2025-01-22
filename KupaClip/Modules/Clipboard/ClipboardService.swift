//
//  ClipboardService.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 04/01/2025.
//
import Foundation
import AppKit
import Combine

class ClipboardService {
    private let pasteboard = NSPasteboard.general
    private let storage: ClipboardStorage
    var bag = Set<AnyCancellable>()
    
    private var activeAppBundleIdentifier: String { NSWorkspace.shared.frontmostApplication?.bundleIdentifier ?? "" }
    
    init(storage: ClipboardStorage, pollingInterval: TimeInterval = 0.7) {
        self.storage = storage
        startObservingClipboard(with: pollingInterval)
    }
    
    deinit {
        bag.removeAll()
    }
    
    private func startObservingClipboard(with interval: TimeInterval) {
        Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] _ in
                self?.pasteboard.changeCount
            }
            .removeDuplicates() // skip if no new clipboard items
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.handleClipboardChange(pasteboard: self.pasteboard, appBundleIdentifier: self.activeAppBundleIdentifier)
            }
            .store(in: &bag)
    }
    
    private func handleClipboardChange(pasteboard: NSPasteboard, appBundleIdentifier: String) {
        // Excluded app
        guard !isAppExcluded(appBundleIdentifier) else { return }
        
        let clipboardItem = CliboardItem(pasteboard: pasteboard, appBundleIdentifier: appBundleIdentifier)
        Log.clipboard.info("------ New clipboard")
        Log.clipboard.info("Content: \(pasteboard.string(forType: .string) ?? "")")
        Log.clipboard.info("Types: \(String(pasteboard.types?.map { $0.rawValue }.joined(separator: ", ") ?? ""))")
        Log.clipboard.info("PasteboardItems: \(String(pasteboard.pasteboardItems?.count ?? 0))")
        
        self.storage.addToHistory(clipboardItem)
    }
    
    private func isAppExcluded(_ app: String) -> Bool {
        let excludedApps = ["test.app"]
        return excludedApps.contains(app)
    }
    
    func writeToClipboard(_ string: String?) {
        guard let string else { return }
        Log.clipboard.info("Inserted new clipboard content: \(string)")
        pasteboard.clearContents()
        pasteboard.setString(string, forType: .string)
    }
}
