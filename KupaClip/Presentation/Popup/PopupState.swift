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
    var activeModule: ModuleDetails
    
    var query: String = "" {
        didSet {
            loadFromStorage()
        }
    }
    
    var popupListViewModels: [String: PopupListViewModel] = [:]
    
    @ObservationIgnored var modules: [Module]

    init(modules: [Module]) {
        self.modules = modules
        self.activeModule = modules.first!.getModuleDetails()
        self.modules.forEach { module in
            popupListViewModels[module.getModuleDetails().name] = PopupListViewModel()
        }
        
        loadFromStorage()
    }
    
    func loadFromStorage() {
        for (key, value) in popupListViewModels {
            let module = modules.first(where: {$0.getModuleDetails().name == key})!
            value.setItems(module.getStorage().getFilteredListOfItems(query: query))
        }
    }
    
    private func getActiveModule() -> Module {
        return modules.first(where: {$0.getModuleDetails().name == activeModule.name})!
    }
    
    private func getActiveViewModel() -> PopupListViewModel {
        return popupListViewModels[activeModule.name]!
    }
    
    func selectPrevious() {
        getActiveViewModel().selectPrevious()
    }
    
    func selectNext() {
        getActiveViewModel().selectNext()
    }
    
    func action() {
        guard let item = getActiveViewModel().selectedItem?.title else { return }
        getActiveModule().getActionHandler().actionOn(on: item)
    }
}
