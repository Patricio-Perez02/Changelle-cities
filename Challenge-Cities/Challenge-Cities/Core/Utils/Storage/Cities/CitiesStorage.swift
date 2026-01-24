//
//  CitiesStorage.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 24/01/2026.
//

import Foundation

protocol CitiesStorageProtocol {
//    var favorites: Set<Int> { get }
    func isFavorite(id: Int) -> Bool
    func toggle(id: Int)
}

final class CitiesStorage: CitiesStorageProtocol {
    private enum LocalConstants {
        enum AppStorageKey: String {
            case citiesFavoritesIds
        }
    }
    
    private let storageManager: StorageManaging
    
    init(
        storageManager: StorageManaging = AppStorageManager()
    ) {
        self.storageManager = storageManager
    }
    
    private var favorites: Set<Int> {
        storageManager.get(for: LocalConstants.AppStorageKey.citiesFavoritesIds.rawValue) ?? []
    }
    
    func isFavorite(id: Int) -> Bool {
        favorites.contains(id)
    }
    
    func toggle(id: Int) {
        var current = favorites
        
        if isFavorite(id: id) {
            current.remove(id)
        } else {
            current.insert(id)
        }
        
        storageManager.set(current, for: LocalConstants.AppStorageKey.citiesFavoritesIds.rawValue)
    }
}
