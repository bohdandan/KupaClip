import SwiftUI


struct Popup: View {
    var dismiss: () -> ()
    
    @State var activeMode: PopupMode = .clipboard
    @State var query: String = ""
    
    @State var clipboard: PopupListViewModel = PopupListViewModel(items: DummyData.clipboard)
    
    @State var snippets: PopupListViewModel = PopupListViewModel(items: DummyData.snippets)
    
    @State var tools: PopupListViewModel = PopupListViewModel(items: DummyData.tools)
    
    var body: some View {
            ZStack {
                VStack {
                    PopupHeader(query: $query, activeMode: $activeMode)
            
                    if (activeMode == .clipboard) {
                        list(viewModel: clipboard)
                        .transition(.asymmetric (
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)
                        ))
                    }
                    
                    if (activeMode == .snippet) {
                        list(viewModel: snippets)
                        .transition(.asymmetric (
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                    }
                    
                    if (activeMode == .tools) {
                        list(viewModel: tools)
                        .transition(.asymmetric (
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .trailing)
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
           handleKeyEvent(event)
           return event
       }
   }
    private func getActiveViewModel() -> PopupListViewModel {
        switch activeMode {
        case .clipboard:
            clipboard
        case .snippet:
            snippets
        default:
            tools
        }
    }
   
   private func handleKeyEvent(_ event: NSEvent) {
       switch event.keyCode {
       case 126:
           getActiveViewModel().selectPrevious()
       case 125:
           getActiveViewModel().selectNext()
       case 53:
           dismiss()
       default:
           break
       }
   }
}

#Preview() {
    Popup(){
        print("Close")
    }
}
