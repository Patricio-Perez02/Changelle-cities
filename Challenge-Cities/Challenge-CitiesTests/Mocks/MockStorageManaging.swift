//
//  MockStorageManaging.swift
//  Challenge-CitiesTests
//

import Foundation
@testable import Challenge_Cities

final class MockStorageManaging: StorageManaging {
    private var storage: [String: Data] = [:]

    func get<T: Codable>(for key: String) -> T? {
        guard let data = storage[key] else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func set<T: Codable>(_ value: T, for key: String) {
        storage[key] = try? JSONEncoder().encode(value)
    }

    func remove(for key: String) {
        storage.removeValue(forKey: key)
    }
}
