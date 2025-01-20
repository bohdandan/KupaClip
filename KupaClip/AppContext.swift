//
//  AppContext.swift
//  KupaClip
//
//  Created by Bohdan Danyliuk on 04/01/2025.
//

final class AppContext {
    public static let shared = AppContext()
    private var storage: [ObjectIdentifier: Any] = [:]

    func set<T>(_ instance: T) {
        let key = ObjectIdentifier(T.self)
        storage[key] = instance
    }

    func get<T>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        return storage[key] as! T
    }
}
