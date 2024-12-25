import SwiftUI


struct Popup: View {
    var dismiss: () -> ()
    
    @State var activeMode: PopupMode = .clipboard
    @State var query: String = ""
    
    let clipboard: [String] = [
        "Lorem ipsum dolor sit amet",
        "Aliquam a sollicitudin",
        "consectetur adipiscing elit",
        "Sed et turpis arcu.",
        "Praesent rutrum nec",
    ]
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
    
    var body: some View {
            ZStack {
                VStack {
                    PopupHeader(query: $query, activeMode: $activeMode)
                    
                    if (activeMode == .clipboard) {
                        VStack {
                            ForEach(Array(clipboard.enumerated()), id: \.offset) { index, item in
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
                        }.padding(.bottom, 3)
                            .transition(.asymmetric (
                                insertion: .move(edge: .leading),
                                removal: .move(edge: .leading)
                            ))
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
                        }.padding(.bottom, 3)
                            .transition(.asymmetric (
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
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
                        }.padding(.bottom, 3)
                            .transition(.asymmetric (
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .trailing)
                            ))
                    }
                    Spacer()
                }
                .frame(width: 350, height: 200)
                .background(.thinMaterial)
                .cornerRadius(10)
            }
    }
}

#Preview() {
    Popup(){
        print("Close")
    }.frame(width: 350, height: 200)
}
