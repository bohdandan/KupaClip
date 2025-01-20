import SwiftUI


struct Popup: View {
    @Environment(\.popupState) var state
    
    init() {
        self.state = AppContext.shared.get(PopupState.self)
        self.state.loadFromStorage()
    }
    
    var body: some View {
            ZStack {
                VStack {
                    PopupHeader(query: $state.query, activeModuleName: $state.activeModuleName, modules: state.modules)
                    
                    ForEach(Array(state.modules.enumerated()), id: \.1.name) { index, module in
                        let insertion: Edge = index == 0 ? .leading : .trailing
                        let removal: Edge = index == state.modules.endIndex - 1 ? .trailing : .leading

                        list(viewModel: state.popupListViewModels[module.name]!)
                        .transition(.asymmetric (
                            insertion: .move(edge: insertion),
                            removal: .move(edge: removal)
                        ))
                    }
                    Spacer()
                }
                .frame(width: 350, height: 245)
                .background(.thinMaterial)
                .cornerRadius(10)
                .onAppear {
                   addKeyEventListener()
                }
                .ignoresSafeArea()
            }
    }
    
    private func list(viewModel: PopupListViewModel) -> some View {
        ScrollViewReader { scrollProxy in
            ScrollView([.vertical]) {
                ForEach(viewModel.items, id:\.id) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        if let index = item.shortcut {
                            Text("⌘\(index)")
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
//    AppContext.set(ClipboardStorage(maxLimit: 5, data: DummyData.clipboard))
//    AppContext.set(SnippetStorage(data: DummyData.snippets))
//    AppContext.set(ToolStorage(data: DummyData.tools))
//    AppContext.set(PopupState())
    return Popup()
}
