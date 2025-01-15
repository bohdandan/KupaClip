//
//  KupaClipApp.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 25/12/2024.
//

import SwiftUI
import SwiftData

@main
struct KupaClipApp: App {
    
    init() {
        Task { @MainActor in
            NSApp.setActivationPolicy(.accessory)
        }
        
        let clipboardStorage = ClipboardStorage(maxLimit: 10)
        AppContext.set(clipboardStorage)
        AppContext.set(ClipboardService(storage: clipboardStorage))
        AppContext.set(SnippetStorage(data: DummyData.snippets))
        AppContext.set(ToolStorage(data: DummyData.tools))
        AppContext.set(PasteService())
        AppContext.set(PopupState())
        AppContext.set(FloatingPanelManager())
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup(id: "setings") {
            MainSettingsView()
        }

        MenuBarExtra("Kupa clip", systemImage: "list.clipboard") {
            SettingsLink{
                Text("Settings")
            }.keyboardShortcut(",", modifiers: .command)
            Divider()
            Button("Quit") {
                exit(0)
            }
        }
    }
}
