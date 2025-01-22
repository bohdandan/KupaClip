import SwiftUI

struct MainSettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gear") {
                GeneralSettingsView()
            }
            Tab("Advanced", systemImage: "star") {
                Text("Advanced")
            }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
    }
}

#Preview() {
    MainSettingsView()
        .frame(width: 350, height: 200)
}
