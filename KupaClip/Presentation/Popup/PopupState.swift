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
    var activeModuleName: String
    
    var query: String = "" {
        didSet {
            loadFromStorage()
        }
    }
    
    var popupListViewModels: [String: PopupListViewModel] = [:]
    
    @ObservationIgnored var modules: [Module]

    init(modules: [Module]) {
        self.modules = modules
        self.activeModuleName = modules.first!.name
        self.modules.forEach { module in
            popupListViewModels[module.name] = PopupListViewModel()
        }
        
        loadFromStorage()
    }
    
    func loadFromStorage() {
        for (key, value) in popupListViewModels {
            let module = modules.first(where: {$0.name == key})!
            value.setItems(module.storage.getFilteredListOfItems(query: query))
        }
    }
    
    func getActiveModule() -> Module {
        return modules.first(where: {$0.name == activeModuleName})!
    }
    
    private func getActiveViewModel() -> PopupListViewModel {
        return popupListViewModels[activeModuleName]!
    }
    
    func selectPrevious() {
        getActiveViewModel().selectPrevious()
    }
    
    func selectNext() {
        getActiveViewModel().selectNext()
    }
    
    func action() {
        guard let item = getActiveViewModel().selectedItem?.title else { return }
        getActiveModule().actionHandler.actionOn(on: item)
    }
    
    func nextModule() {
        guard let currentIndex = modules.firstIndex(where: { $0.name == activeModuleName }) else {
            return
        }
        let nextIndex = (currentIndex + 1) % modules.count
        activeModuleName = modules[nextIndex].name
    }
    
    func isActive(_ module: Module) -> Bool {
        return activeModuleName == module.name
    }
}
