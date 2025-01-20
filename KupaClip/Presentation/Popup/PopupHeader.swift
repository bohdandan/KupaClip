import SwiftUI

struct PopupHeader: View {
    @Binding var query: String
    @Binding var activeModuleName: String
    @ObservationIgnored var modules: [Module]
    
    func next() {
//        guard let currentIndex = PopupMode.allCases.firstIndex(of: activeMode) else { return }
//        let nextIndex = (currentIndex + 1) % PopupMode.allCases.count
//        activeMode = PopupMode.allCases[nextIndex]
    }
    
    func isActive(_ module: Module) -> Bool {
        return activeModuleName == module.name
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .frame(width: 15, height: 25)
//                .foregroundColor(activeModule.getModuleDetails().color)
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
            ForEach(modules, id: \.name) { module in
                let moduleDetails = module.getModuleDetails()
        
                Image(systemName: moduleDetails.iconSystemName)
                    .frame(width: 15)
                    .foregroundColor(moduleDetails.color)
                    .help(module.name)
                    .opacity(isActive(module) ? 0.8 : 0.5)
                    .symbolEffect(.scale.up, isActive: isActive(module))
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.2)) {
                            activeModuleName = module.name
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
