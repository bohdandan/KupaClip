import AppKit
import SwiftUI
class ContentPanel: NSPanel {
    private var hostingView: NSHostingView<AnyView>?
    private let clipboardManager: ClipboardManager  // Add property
    
    init(clipboardManager: ClipboardManager) {
        self.clipboardManager = clipboardManager
        
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 350, height: 200),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        setupWindow()
        setupContentView()
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override func resignKey() {
        super.resignKey()
        close()
    }
    
    override func close() {
        hostingView?.removeFromSuperview()
        hostingView = nil
        super.close()
    }
    
    private func setupWindow() {
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        level = .floating
        isMovableByWindowBackground = false
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        
        collectionBehavior = [.canJoinAllSpaces, .transient]
        animationBehavior = .utilityWindow
    }
    
    private func setupContentView() {
        print("Setting up content view...")
        
        let contentView = Popup { [weak self] in
            print("Popup dismiss called")
            self?.close()
        }
        
        let contentWithEnvironment = AnyView(
            contentView
                .environmentObject(clipboardManager)  // Use the stored manager
                .frame(width: 350, height: 200)
        )
        
        let hosting = NSHostingView(rootView: contentWithEnvironment)
        self.hostingView = hosting
        self.contentView = hosting
        
        hosting.frame = NSRect(x: 0, y: 0, width: 350, height: 200)
        
        if let screen = NSScreen.main {
            setFrameOrigin(panelPosition(mousePosition: NSEvent.mouseLocation,
                                       screenFrame: screen.visibleFrame,
                                       hostingFrame: hosting.frame))
        }
    }
    
    private func panelPosition(mousePosition: NSPoint, screenFrame: NSRect, hostingFrame: NSRect) -> NSPoint {
        // Calculate initial position centered below the mouse
        var position = NSPoint(
            x: mousePosition.x - (hostingFrame.width / 2),
            y: mousePosition.y - hostingFrame.height - 10 // Position window below cursor with small gap
        )
        
        let padding: CGFloat = 20
        
        // Ensure window stays within screen bounds
        // Check right edge
        if position.x + hostingFrame.width + padding > screenFrame.maxX {
            position.x = screenFrame.maxX - hostingFrame.width - padding
        }
        // Check left edge
        if position.x < screenFrame.minX + padding {
            position.x = screenFrame.minX + padding
        }
        // Check bottom edge
        if position.y < screenFrame.minY + padding {
            position.y = mousePosition.y + padding // Position above cursor if too close to bottom
        }
        // Check top edge
        if position.y + hostingFrame.height > screenFrame.maxY - padding {
            position.y = screenFrame.maxY - hostingFrame.height - padding
        }
        
        return position
    }
    
}
