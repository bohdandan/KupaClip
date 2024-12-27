
import SwiftUI

struct Popup: View {
    var dismiss: () -> ()
    
    @EnvironmentObject private var clipboardManager: ClipboardManager
    @State var activeMode: PopupMode = .clipboard
    @State var query: String = ""
    
    let snippets: [String] = [
        "My mobile",
        "My email",
        "Partner's mobile",
        "Partner's email"
    ]
    let tools: [String] = [
        "Capitalise words",
        "To lower case",
        "Trim",
        "Snake case",
        "Camel case",
    ]
    
    var filteredClipboardItems: [ClipboardItem] {
        if query.isEmpty {
            return clipboardManager.clipboardItems
        }
        return clipboardManager.clipboardItems.filter { $0.content.localizedCaseInsensitiveContains(query) }
    }
    
    var body: some View {
        ZStack {
            VStack {
                PopupHeader(query: $query, activeMode: $activeMode)
                
                if (activeMode == .clipboard) {
                    VStack {
                        if clipboardManager.clipboardItems.isEmpty {
                            VStack {
                                Image(systemName: "clipboard")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                Text("No clipboard history")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxHeight: .infinity)
                        } else {
                            ForEach(Array(filteredClipboardItems.prefix(10).enumerated()), id: \.1.id) { index, item in
                                HStack {
                                    Text(item.content)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                    Spacer()
                                    Text("⌘\(index + 1)")
                                        .opacity(0.6)
                                        .monospaced()
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    handleItemSelection(item: item)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 3)
                }
                
                if (activeMode == .snippet) {
                    VStack {
                        ForEach(Array(snippets.enumerated()), id: \.offset) { index, item in
                            HStack {
                                Text(item)
                                Spacer()
                                Text("⌘\(index + 1)")
                                    .opacity(0.6)
                                    .monospaced()
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 1)
                        }
                    }
                    .padding(.bottom, 3)
                }
                
                if (activeMode == .tools) {
                    VStack {
                        ForEach(Array(tools.enumerated()), id: \.offset) { index, item in
                            HStack {
                                Text(item)
                                Spacer()
                                Text("⌘\(index + 1)")
                                    .opacity(0.6)
                                    .monospaced()
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 1)
                        }
                    }
                    .padding(.bottom, 3)
                }
                Spacer()
            }
            .frame(width: 350, height: 200)
            .background(.thinMaterial)
            .cornerRadius(10)
            .onKeyPress { press in
                if press.modifiers.contains(.command),
                   let number = Int(String(press.key.character)),
                   number >= 1 && number <= 9 {
                    handleHotkeySelection(index: number - 1)
                    return .handled
                }
                return .ignored
            }
        }
    }
    
    private func handleItemSelection(item: ClipboardItem) {
        clipboardManager.pasteToActiveApp(item: item)
        dismiss()
    }
    
    private func handleHotkeySelection(index: Int) {
        switch activeMode {
        case .clipboard:
            if index < filteredClipboardItems.count {
                let item = filteredClipboardItems[index]
                handleItemSelection(item: item)
            }
        case .snippet:
            if index < snippets.count {
                // Handle snippet selection (to be implemented)
                dismiss()
            }
        case .tools:
            if index < tools.count {
                // Handle tool selection (to be implemented)
                dismiss()
            }
        }
    }
}
