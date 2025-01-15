//
//  PopupState.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 06/01/2025.
//
import SwiftUI
import KeyboardShortcuts

@Observable
class PopupState {
    var activeMode: PopupMode = .clipboard
    
    var query: String = "" {
        didSet {
            filterLists()
        }
    }
    
    var clipboard: PopupListViewModel = PopupListViewModel()
    var snippets: PopupListViewModel = PopupListViewModel()
    var tools: PopupListViewModel = PopupListViewModel()

    init() {
        loadFromStorage()
    }
    
    func loadFromStorage() {
        clipboard = PopupListViewModel(AppContext.get(ClipboardStorage.self).data.map { $0.content })
        snippets = PopupListViewModel(AppContext.get(SnippetStorage.self).data)
        tools = PopupListViewModel(AppContext.get(ToolStorage.self).data)
    }
    
    func filterLists() {
        clipboard.updateFilteredItems(query: query)
        snippets.updateFilteredItems(query: query)
        tools.updateFilteredItems(query: query)
    }
    
    func isClipboard() -> Bool {
        return activeMode == .clipboard
    }
    
    func isSnippets() -> Bool {
        return activeMode == .snippets
    }
    
    func isTools() -> Bool {
        return activeMode == .tools
    }
    
    private func getActiveViewModel() -> PopupListViewModel {
        switch activeMode {
        case .clipboard:
            clipboard
        case .snippets:
            snippets
        default:
            tools
        }
    }
    
    func selectPrevious() {
        getActiveViewModel().selectPrevious()
    }
    
    func selectNext() {
        getActiveViewModel().selectNext()
    }
    
    func action() {
        guard isClipboard() else { return }
        AppContext.get(ClipboardService.self).writeToClipboard(clipboard.selectedItem?.title)
        AppContext.get(PasteService.self).pasteToActiveApp()
    }
}
