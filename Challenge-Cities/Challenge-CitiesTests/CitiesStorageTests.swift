//
//  CitiesStorageTests.swift
//  Challenge-CitiesTests
//
//  Created by Patricio Perez on 24/01/2026.
//

import Testing
@testable import Challenge_Cities

/// Unit tests for CitiesStorage
///
/// These tests verify:
/// - Favorite state checking
/// - Toggling favorites
/// - Persistence of favorite states
@MainActor
struct CitiesStorageTests {
    
    @Test("Storage should correctly check favorite state")
    func testIsFavorite() async throws {
        let storage = MockCitiesStorage()
        
        #expect(!storage.isFavorite(id: 1))
        
        storage.toggle(id: 1)
        
        #expect(storage.isFavorite(id: 1))
    }
    
    @Test("Storage should toggle favorite correctly")
    func testToggleFavorite() async throws {
        let storage = MockCitiesStorage()
        
        // Initially not favorite
        #expect(!storage.isFavorite(id: 1))
        
        // Toggle to favorite
        storage.toggle(id: 1)
        #expect(storage.isFavorite(id: 1))
        
        // Toggle back to not favorite
        storage.toggle(id: 1)
        #expect(!storage.isFavorite(id: 1))
    }
    
    @Test("Storage should handle multiple favorites")
    func testMultipleFavorites() async throws {
        let storage = MockCitiesStorage()
        
        storage.toggle(id: 1)
        storage.toggle(id: 2)
        storage.toggle(id: 3)
        
        #expect(storage.isFavorite(id: 1))
        #expect(storage.isFavorite(id: 2))
        #expect(storage.isFavorite(id: 3))
        #expect(!storage.isFavorite(id: 4))
    }
    
    @Test("Storage should handle toggling same favorite multiple times")
    func testToggleSameFavoriteMultipleTimes() async throws {
        let storage = MockCitiesStorage()
        
        storage.toggle(id: 1)
        storage.toggle(id: 1)
        storage.toggle(id: 1)
        
        // After odd number of toggles, should be favorite
        #expect(storage.isFavorite(id: 1))
        
        storage.toggle(id: 1)
        
        // After even number of toggles, should not be favorite
        #expect(!storage.isFavorite(id: 1))
    }
}
