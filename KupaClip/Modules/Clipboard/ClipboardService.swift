//
//  ClipboardService.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 04/01/2025.
//
import Foundation
import AppKit

class ClipboardService {
    var clipboardContent: String?
    private var timer: Timer?
    private var previousContent: String?
    private let pasteboard = NSPasteboard.general
    private let storage: ClipboardStorage
    
    init(storage: ClipboardStorage, pollingInterval: TimeInterval = 0.5) {
        self.storage = storage
        startObserving(with: pollingInterval)
    }
    
    deinit {
        stopObserving()
    }
    
    private func startObserving(with interval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    private func stopObserving() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkClipboard() {
        guard let newContent = pasteboard.string(forType: .string) else { return }
        
        if newContent != previousContent {
            previousContent = newContent
            DispatchQueue.main.async {
                print("New clip: \(newContent)")
                self.clipboardContent = newContent
                self.storage.addToHistory(newContent)
            }
        }
    }
}
