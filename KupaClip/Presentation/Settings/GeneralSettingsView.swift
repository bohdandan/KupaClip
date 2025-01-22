import SwiftUI
import KeyboardShortcuts
import Defaults

struct GeneralSettingsView: View {
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0

    var body: some View {
        Form {
            Form {
                KeyboardShortcuts.Recorder("Toggle Popup:", name: .togglePopup)
                
                Defaults.Toggle(key: .insertIntoActiveApp) {
                    Text("Insert into active application")
                }.help(Text("Insert into active application"))
            }
        }
    }
}
