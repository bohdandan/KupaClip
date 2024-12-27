import SwiftUI
import SwiftData

@main
struct KupaClipApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var clipboardManager = ClipboardManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Snippet.self,
            Folder.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        Settings {
            MainSettingsView()
                .environmentObject(clipboardManager)
        }
        
        MenuBarExtra("Paste paste paste", systemImage: "list.clipboard") {
            SettingsLink {
                Text("Settings")
            }
            .keyboardShortcut(",", modifiers: .command)
            
            Divider()
            
            if !clipboardManager.clipboardItems.isEmpty {
                ForEach(clipboardManager.clipboardItems.prefix(5)) { item in
                    Button(item.content) {
                        clipboardManager.copyToClipboard(item: item)
                    }
                }
                Divider()
            }
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
        .menuBarExtraStyle(.window)
        .modelContainer(sharedModelContainer)
        .environmentObject(clipboardManager)
    }
}
