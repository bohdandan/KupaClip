import SwiftUI


struct Popup: View {
    @State var state: PopupState
    @Environment(\.openSettings) var openSettings
    
    init() {
        self.state = AppContext.shared.get(PopupState.self)
        self.state.loadFromStorage()
    }
    
    func trancateListItemTitle(_ text: String) -> String {
        return String(text.prefix(300)
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\t", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    var body: some View {
            ZStack {
                VStack (spacing: 0) {
                    PopupHeader(state: $state)
                    
                    ForEach(Array(state.modules.enumerated()), id: \.1.name) { index, module in
                        let insertion: Edge = index == 0 ? .leading : .trailing
                        let removal: Edge = index == state.modules.endIndex - 1 ? .trailing : .leading

                        if (state.activeModuleName == module.name) {
                            VStack {
                                HStack {
                                    Spacer()
                                        .frame(width: 13)
                                        .background(
                                            Rectangle()
                                                .fill(Color.gray)
                                                .opacity(0.5)
                                                .frame(height: 1))
                                    
                                    Text(module.name)
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .opacity(0.5)
                                        .padding(.horizontal, 10)
                                        .padding(.top, 3)
                                        
                                    Spacer().background(
                                        Rectangle()
                                            .fill(Color.gray)
                                            .opacity(0.5)
                                            .frame(height: 1)
                                            .padding(.top, 0))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 0)
                                    
                                list(viewModel: state.popupListViewModels[module.name]!)
                                   
                            }
                            .transition(.asymmetric (
                                insertion: .move(edge: insertion),
                                removal: .move(edge: removal)
                            ))
                        }
                    }
                    Divider()
                        .padding(.vertical, 0)
                    HStack (spacing: 0) {
                        Spacer()
                        Text("⌘,")
                            .opacity(0.5)
                            .padding(0)
                        Image(systemName: "gear")
                            .frame(width: 15)
                            .foregroundColor(.gray)
                            .help("Settings")
                            .opacity(0.5)
                            .padding(.leading, 3)
                            .padding(.trailing, 10)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.2)) {
                                    openSettings()
                                }
                            }
                    }
                }
                .frame(width: 350, height: 245)
                .background(.thinMaterial)
                .cornerRadius(10)
                .onAppear {
                   addKeyEventListener()
                }
            }
    }
    
    private func list(viewModel: PopupListViewModel) -> some View {
        ScrollViewReader { scrollProxy in
            ScrollView([.vertical]) {
                ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text(trancateListItemTitle(item.title))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                        if (index < 9) {
                            Text("⌘\(index + 1)")
                                .opacity(0.6)
                                .monospaced()
                        }
                    }
                    .id(item.id)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 1)
                    .foregroundStyle(viewModel.isSelected(item: item) ? Color.white : .primary)
                    .background(viewModel.isSelected(item: item) ? Color.accentColor.opacity(0.8) : .clear)
                    .contentShape(Rectangle())
                    .clipShape(.rect(cornerRadius: 2))
                    .onTapGesture {
                        viewModel.selectedItem = item
                        withAnimation {
                            scrollProxy.scrollTo(item.id)
                        }
                    }
                }
            }.padding(.bottom, 3)
            .transition(.asymmetric (
                insertion: .move(edge: .leading),
                removal: .move(edge: .leading)
            ))
            .onChange(of: viewModel.selectedItem) {
                if let selectedItem = viewModel.selectedItem {
                    withAnimation {
                        scrollProxy.scrollTo(selectedItem.id)
                    }
                }
            }
        }
    }
    
    private func addKeyEventListener() {
       NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
           return handleKeyEvent(event) ? nil : event
       }
   }
   
    private func handleKeyEvent(_ event: NSEvent) -> Bool {
        Log.clipboard.log("keyboard event: \(event.keyCode)")
        
        switch event.keyCode {
        case 126: // Up arrow key
            state.selectPrevious()
            return true
        case 125: // Down arrow key
            state.selectNext()
            return true
        case 53: // Escape key
            if (state.query.isEmpty) {
               dismiss()
            } else {
               state.query = ""
            }
            return true
        case 36: // Enter/Return key
            state.action()
            dismiss()
            return true
        default:
            return false
        }
    }
    
    private func dismiss() {
        AppContext.shared.get(FloatingPanelManager.self).close()
    }
}
    
#Preview() {
    
    AppContext.shared.set(PopupState(modules:
                            [
                                ClipboardModule(AppContext.shared),
                                SnipetModule(AppContext.shared),
                                ToolModule(AppContext.shared)
                            ]))
//    AppContext.shared.get(ClipboardStorage.self)
//        .populateData(DummyData.clipboard.map{CliboardItem()})

    return Popup()
}
