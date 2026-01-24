//
//  AppStorageManager.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 24/01/2026.
//

import Foundation

/// Abstraction for a persistent key–value storage system.
///
/// `StorageManaging` defines a generic interface to store, retrieve and remove
/// values conforming to `Codable`, decoupling the storage mechanism from its
/// concrete implementation (e.g. `UserDefaults`, Keychain, files, etc.).
///
/// This enables:
/// - Easier testing (mock implementations)
/// - Swapping storage backends
/// - Better separation of concerns
protocol StorageManaging {
    
    /// Retrieves a stored value for the given key.
    ///
    /// - Parameter key: The key associated with the stored value.
    /// - Returns: The decoded value of the requested type if it exists,
    ///   or `nil` if no data is found or decoding fails.
    func get<T: Codable>(for key: String) -> T?
    
    /// Stores a value for the given key.
    ///
    /// The value is encoded using `JSONEncoder` before being persisted.
    ///
    /// - Parameters:
    ///   - value: The value to store. Must conform to `Codable`.
    ///   - key: The key under which the value will be stored.
    func set<T: Codable>(_ value: T, for key: String)
    
    /// Removes the stored value associated with the given key.
    ///
    /// - Parameter key: The key of the value to remove.
    func remove(for key: String)
}

final class AppStorageManager: StorageManaging {
    // MARK: - Private properties
    private let userDefaults: UserDefaults

    // MARK: - Initialization
    /// Creates a new `AppStorageManager` instance.
    ///
    /// - Parameter userDefaults: The `UserDefaults` instance used as the
    ///   storage backend. Defaults to `.standard`.
    ///
    /// Injecting `UserDefaults` allows:
    /// - Isolated and predictable unit testing
    /// - Avoiding direct dependency on `.standard`
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - StorageManaging methods
    func get<T>(for key: String) -> T? where T : Decodable, T : Encodable {
        guard let data = userDefaults.data(forKey: key)
        else { return nil }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func set<T>(_ value: T, for key: String) where T : Decodable, T : Encodable {
        let data = try? JSONEncoder().encode(value)
        userDefaults.set(data, forKey: key)
    }
    
    func remove(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
