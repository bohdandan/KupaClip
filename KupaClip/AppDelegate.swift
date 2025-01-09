import SwiftUI
import HotKey

final class AppDelegate: NSObject, NSApplicationDelegate {
    var contentWindow: NSWindow?
    var hotKey: HotKey?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Close Settings Window on startup
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        setupHotkey()
        let clipboardStorage = ClipboardStorage(maxLimit: 10)
        AppContext.set(clipboardStorage)
        AppContext.set(ClipboardService(storage: clipboardStorage))
        AppContext.set(SnippetStorage(data: DummyData.snippets))
        AppContext.set(ToolStorage(data: DummyData.tools))
    }

    private func setupHotkey() {
        hotKey = HotKey(key: .p, modifiers: [.command, .shift])
        hotKey?.keyDownHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.showContentWindow()
            }
        }
    }
    
    func showContentWindow() {
        self.closeReviewWindow()
        
        let contentPanel = ContentPanel()
        
        contentWindow = contentPanel
        
        contentPanel.makeKeyAndOrderFront(nil)
        contentPanel.makeKey()
    }
    
    private func closeReviewWindow() {
        if let window = contentWindow {
            window.close()
            contentWindow = nil
        }
    }
}
