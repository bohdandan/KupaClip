//
//  ClipboardService.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 04/01/2025.
//
import Foundation
import AppKit
import Combine

class ClipboardService {
    private let pasteboard = NSPasteboard.general
    private let storage: ClipboardStorage
    var bag = Set<AnyCancellable>()
    
    init(storage: ClipboardStorage, pollingInterval: TimeInterval = 0.7) {
        self.storage = storage
        startObserving(with: pollingInterval)
    }
    
    deinit {
        bag.removeAll()
    }
    
    private func startObserving(with interval: TimeInterval) {
        Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] _ -> String? in
                self?.pasteboard.string(forType: .string)
            }
            .removeDuplicates()
            .compactMap { $0 } // Remove nil values
            .sink { [weak self] newContent in
               self?.handleClipboardChange(newContent)
            }
            .store(in: &bag)
    }
    
    private func handleClipboardChange(_ newContent: String) {
        Log.clipboard.info("New clipboard content: \(newContent)")
        self.storage.addToHistory(newContent)
    }
    
    func writeToClipboard(_ string: String?) {
        guard let string else { return }
        Log.clipboard.info("Inserted new clipboard content: \(string)")
        pasteboard.clearContents()
        pasteboard.setString(string, forType: .string)
    }
}
