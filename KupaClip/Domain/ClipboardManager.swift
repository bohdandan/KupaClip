import AppKit
import SwiftUI
import Combine

@MainActor
class ClipboardManager: ObservableObject {
    @Published var clipboardItems: [ClipboardItem] = []
    private var timer: Timer?
    private var lastChangeCount: Int
    private let maxItems = 50
    
    init() {
        self.lastChangeCount = NSPasteboard.general.changeCount
        startMonitoring()
    }
    
    private func startMonitoring() {
        print("ClipboardManager: Starting monitoring")
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                Task { @MainActor [weak self] in
                    self?.checkClipboard()
                }
            }
        }
    }
    
    private func checkClipboard() {
        let pasteboard = NSPasteboard.general
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount
            
            if let newString = pasteboard.string(forType: .string) {
                if self.clipboardItems.first?.content != newString {
                    let newItem = ClipboardItem(content: newString)
                    self.clipboardItems.insert(newItem, at: 0)
                    
                    if self.clipboardItems.count > self.maxItems {
                        self.clipboardItems.removeLast()
                    }
                }
            }
        }
    }
    
    func copyToClipboard(item: ClipboardItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(item.content, forType: .string)
    }
    
    func pasteToActiveApp(item: ClipboardItem) {
        copyToClipboard(item: item)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let source = CGEventSource(stateID: .combinedSessionState) {
                // Create keydown event for Command+V
                let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
                keyVDown?.flags = .maskCommand
                
                // Create keyup event for Command+V
                let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
                keyVUp?.flags = .maskCommand
                
                // Hide our app and activate the target app
                NSApp.hide(nil)
                
                // Post the events
                keyVDown?.post(tap: .cghidEventTap)
                keyVUp?.post(tap: .cghidEventTap)
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

struct ClipboardItem: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let timestamp = Date()
}

