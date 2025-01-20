//
//  Logger.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 10/01/2025.
//
import os

struct Log {
    static let common = Logger(subsystem: "KupaClip", category: "KupaClip")
    static let clipboard = Logger(subsystem: "Clipboard", category: "Clipboard")
    static let snippet = Logger(subsystem: "Snippet", category: "Snippet")
    static let tool = Logger(subsystem: "Tool", category: "Tool")
}
