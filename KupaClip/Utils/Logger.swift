//
//  Logger.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 10/01/2025.
//
import os

class Log {
    static let clipboard = Logger(subsystem: "Clipboard", category: "Clipboard")
    static let snippet = Logger(subsystem: "Snippet", category: "Snippet")
    static let tool = Logger(subsystem: "Tool", category: "Tool")
}
