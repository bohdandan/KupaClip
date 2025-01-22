import SwiftUI
import KeyboardShortcuts
import Defaults

struct GeneralSettingsView: View {

    var body: some View {
        Form {
            Form {
                KeyboardShortcuts.Recorder("Open Clipboard History", name: .openClipboard)
                KeyboardShortcuts.Recorder("Open Snippets", name: .openSnippets)
                KeyboardShortcuts.Recorder("Open tools", name: .openTools)
                
                Defaults.Toggle(key: .insertIntoActiveApp) {
                    Text("Insert into active application")
                }.help(Text("Insert into active application"))
            }
        }
    }
}
