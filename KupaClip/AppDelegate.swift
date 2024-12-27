import SwiftUI
import HotKey

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var contentPanel: ContentPanel?
    private var hotKey: HotKey?
    public let clipboardManager = ClipboardManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Close Settings Window on startup
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        setupHotkey()
        
        // Request accessibility permissions if needed
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options)
    }

    private func setupHotkey() {
        hotKey = HotKey(key: .p, modifiers: [.command, .shift]) { [weak self] in
            Task { @MainActor in
                self?.showContentPanel()
            }
        }
    }
    
    private func showContentPanel() {
        if let panel = contentPanel {
            panel.close()
            contentPanel = nil
        }
        
        let panel = ContentPanel(clipboardManager: clipboardManager)
        contentPanel = panel
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
