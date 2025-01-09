//
//  PopupState.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 06/01/2025.
//
import SwiftUI

@Observable
class PopupState {
    
    var activeMode: PopupMode = .clipboard
    
    var query: String = "" {
        didSet {
            clipboard.updateFilteredItems(query: query)
            snippets.updateFilteredItems(query: query)
            tools.updateFilteredItems(query: query)
        }
    }
    
    var clipboard: PopupListViewModel = PopupListViewModel()
    
    var snippets: PopupListViewModel = PopupListViewModel()

    var tools: PopupListViewModel = PopupListViewModel()


    init() {
        clipboard.items = AppContext.get(ClipboardStorage.self)?.data ?? []
        snippets.items = AppContext.get(SnippetStorage.self)?.data ?? []
        tools.items = AppContext.get(ToolStorage.self)?.data ?? []
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
}
