//
//  MockCitiesStorage.swift
//  Challenge-CitiesTests
//
//  Created by Patricio Perez on 24/01/2026.
//

import Foundation
@testable import Challenge_Cities

final class MockCitiesStorage: CitiesStorageProtocol {
    private var favorites: Set<Int> = []
    
    func isFavorite(id: Int) -> Bool {
        favorites.contains(id)
    }
    
    func toggle(id: Int) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
    }
    
    func getFavorites() -> Set<Int> {
        return favorites
    }
}
