//
//  ClipboardSettingsView.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 22/01/2025.
//

import SwiftUI
import KeyboardShortcuts
import Defaults

struct ClipboardSettingsView: View {
    @Default(.clipboardStorageSize) private var clipboardStorageSize
    
    var body: some View {
        Form {
            TextField("", value: $clipboardStorageSize, format: .number)
        }
    }
}
