import SwiftUI

struct PopupHeader: View {
    @Binding var state: PopupState
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .frame(width: 15, height: 25)
                .foregroundColor(state.getActiveModule().moduleDetails.color)
                .bold()
                .opacity(0.6)
            
            TextField("Search or ⇥", text: $state.query)
                .disableAutocorrection(true)
                .lineLimit(1)
                .textFieldStyle(.plain)
                .strikethrough(color: .green)
                .onSubmit { print("Submit") }
                .onKeyPress(keys: [.tab]) { press in
                    withAnimation(.easeIn(duration: 0.2)) {
                        state.nextModule()
                    }
                    return .handled
                }
            ForEach(state.modules, id: \.name) { module in
                let moduleDetails = module.moduleDetails
        
                Image(systemName: moduleDetails.iconSystemName)
                    .frame(width: 15)
                    .foregroundColor(moduleDetails.color)
                    .help(module.name)
                    .opacity(state.isActive(module) ? 0.8 : 0.5)
                    .symbolEffect(.scale.up, isActive: state.isActive(module))
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.2)) {
                            state.activeModuleName = module.name
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
