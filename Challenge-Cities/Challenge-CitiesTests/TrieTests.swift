//
//  TrieTests.swift
//  Challenge-CitiesTests
//
//  Created by Patricio Perez on 24/01/2026.
//

import Testing
@testable import Challenge_Cities

/// Unit tests for the Trie data structure
///
/// These tests verify:
/// - Insertion of values with keys
/// - Prefix-based search functionality
/// - Case-insensitive search
/// - Empty prefix handling
/// - Removal of all values
///
@MainActor
struct TrieTests {
    
    // MARK: - Insertion Tests
    @Test("Trie should insert values correctly")
    func testInsert() async throws {
        let trie = Trie<String>()
        
        trie.insert(key: "apple", value: "apple")
        trie.insert(key: "app", value: "app")
        trie.insert(key: "application", value: "application")
        
        let results = trie.search(prefix: "app")
        #expect(results.count == 3)
        #expect(results.contains("apple"))
        #expect(results.contains("app"))
        #expect(results.contains("application"))
    }
    
    @Test("Trie should handle duplicate keys by storing multiple values")
    func testInsertDuplicateKeys() async throws {
        let trie = Trie<String>()
        
        trie.insert(key: "test", value: "value1")
        trie.insert(key: "test", value: "value2")
        trie.insert(key: "test", value: "value3")
        
        let results = trie.search(prefix: "test")
        #expect(results.count == 3)
        #expect(results.contains("value1"))
        #expect(results.contains("value2"))
        #expect(results.contains("value3"))
    }
    
    // MARK: - Search Tests
    
    @Test("Trie should find exact matches")
    func testSearchExactMatch() async throws {
        let trie = Trie<String>()
        
        trie.insert(key: "hello", value: "hello")
        trie.insert(key: "world", value: "world")
        
        let results = trie.search(prefix: "hello")
        #expect(results.count == 1)
        #expect(results.first == "hello")
    }
    
    @Test("Trie should find all values with matching prefix")
    func testSearchPrefix() async throws {
        let trie = Trie<String>()
        
        trie.insert(key: "cat", value: "cat")
        trie.insert(key: "car", value: "car")
        trie.insert(key: "card", value: "card")
        trie.insert(key: "dog", value: "dog")
        
        let results = trie.search(prefix: "ca")
        #expect(results.count == 3)
        #expect(results.contains("cat"))
        #expect(results.contains("car"))
        #expect(results.contains("card"))
        #expect(!results.contains("dog"))
    }
    
    @Test("Trie search should be case-insensitive")
    func testSearchCaseInsensitive() async throws {
        let trie = Trie<String>()
        
        trie.insert(key: "Apple", value: "Apple")
        trie.insert(key: "APPLE", value: "APPLE")
        trie.insert(key: "apple", value: "apple")
        
        let results1 = trie.search(prefix: "app")
        #expect(results1.count == 3)
        
        let results2 = trie.search(prefix: "APP")
        #expect(results2.count == 3)
        
        let results3 = trie.search(prefix: "App")
        #expect(results3.count == 3)
    }
    
    @Test("Trie should return empty array for non-existent prefix")
    func testSearchNonExistentPrefix() async throws {
        let trie = Trie<String>()
        
        trie.insert(key: "hello", value: "hello")
        
        let results = trie.search(prefix: "xyz")
        #expect(results.isEmpty)
    }
    
    @Test("Trie should return empty array for empty prefix")
    func testSearchEmptyPrefix() async throws {
        let trie = Trie<String>()
        
        trie.insert(key: "hello", value: "hello")
        trie.insert(key: "world", value: "world")
        
        let results = trie.search(prefix: "")
        #expect(results.isEmpty)
    }
    
    @Test("Trie should handle search in empty trie")
    func testSearchEmptyTrie() async throws {
        let trie = Trie<String>()
        
        let results = trie.search(prefix: "anything")
        #expect(results.isEmpty)
    }
    
    // MARK: - Remove All Tests
    @Test("Trie should remove all values correctly")
    func testRemoveAll() async throws {
        let trie = Trie<String>()
        
        trie.insert(key: "test1", value: "value1")
        trie.insert(key: "test2", value: "value2")
        trie.insert(key: "test3", value: "value3")
        
        #expect(trie.search(prefix: "test").count == 3)
        
        trie.removeAll()
        
        #expect(trie.search(prefix: "test").isEmpty)
        #expect(trie.search(prefix: "test1").isEmpty)
    }
}
