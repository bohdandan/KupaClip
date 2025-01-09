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
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

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
        Settings {
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
