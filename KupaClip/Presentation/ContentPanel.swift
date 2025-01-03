import AppKit
import SwiftUI

//Inspired - https://github.com/Archetapp/FloatingPanelTutorial
class ContentPanel: NSPanel {
    
    init() {
        super.init(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel, .titled],
            backing: .buffered,
            defer: true
        )
        
        setupWindow()
        setupContentView()
    }
    
    private func setupWindow() {
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        level = .floating
        isMovableByWindowBackground = true
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        animationBehavior = .utilityWindow
        
        collectionBehavior = [
            .canJoinAllSpaces,
            .stationary
        ]
    }
    
    private func setupContentView() {
        let contentView = Popup() {
            self.close()
        }
        
        let hostingView = NSHostingView(rootView: contentView)
        self.contentView = hostingView
        
        hostingView.setFrameSize(hostingView.fittingSize)
        
        if let screen = NSScreen.main {
            setFrameOrigin(panelPosition(mousePosition: NSEvent.mouseLocation,
                                         screenFrame: screen.visibleFrame,
                                         hostingFrame: hostingView.frame))
            setContentSize(hostingView.frame.size)
        }
    }
    
    private func panelPosition(mousePosition: NSPoint, screenFrame: NSRect, hostingFrame: NSRect) -> NSPoint {
        var position = NSPoint(x: mousePosition.x - 40, y: mousePosition.y - hostingFrame.height + 20)
        let padding: CGFloat = 20
        if (position.x + hostingFrame.width + padding > screenFrame.maxX) {
            position.x = screenFrame.maxX - hostingFrame.width - padding
        }
                
        return position
    }
    
    override func resignKey() {
        super.resignKey()
        close()
    }
}
