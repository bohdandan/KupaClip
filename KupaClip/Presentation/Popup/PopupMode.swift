import SwiftUI

enum PopupMode: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case clipboard
    case snippet
    case tools
}
