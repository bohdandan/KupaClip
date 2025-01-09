import SwiftUI

struct PopupHeader: View {
    @Binding var query: String
    @Binding var activeMode: PopupMode
    
    struct PopupModeDetails {
        var systemName : String
        var name : String
        var color : Color
    }
    
    func next() {
        guard let currentIndex = PopupMode.allCases.firstIndex(of: activeMode) else { return }
        let nextIndex = (currentIndex + 1) % PopupMode.allCases.count
        activeMode = PopupMode.allCases[nextIndex]
    }
    
    func getDetails(mode: PopupMode) -> PopupModeDetails {
        switch mode {
        case .clipboard:
            return PopupModeDetails(systemName: "clipboard", name: "Clipboard", color: .orange)
        case .snippets:
            return PopupModeDetails(systemName: "text.redaction", name: "Snippets", color: .green)
        case .tools:
            return PopupModeDetails(systemName: "wrench.and.screwdriver", name: "Tools", color: .blue)
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .frame(width: 15, height: 25)
                .foregroundColor(getDetails(mode: activeMode).color)
                .bold()
                .opacity(0.6)
            
            TextField("Search or ⇥", text: $query)
                .disableAutocorrection(true)
                .lineLimit(1)
                .textFieldStyle(.plain)
                .strikethrough(color: .green)
                .onSubmit { print("Submit") }
                .onKeyPress(keys: [.tab]) { press in
                    withAnimation(.easeIn(duration: 0.2)) {
                        next()
                    }
                    return .handled
                }
            
            ForEach(PopupMode.allCases) { mode in
                let modeDetails : PopupModeDetails = getDetails(mode: mode)
                Image(systemName: modeDetails.systemName)
                    .frame(width: 15)
                    .foregroundColor(modeDetails.color)
                    .help(modeDetails.name)
                    .opacity(mode == activeMode ? 0.8 : 0.5)
                    .symbolEffect(.scale.up, isActive: mode == activeMode)
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.2)) {
                            activeMode = mode
                        }
                    }
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 2)
        
        Divider()
            .padding(.vertical, 0)
    }
}
