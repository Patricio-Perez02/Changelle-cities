//
//  ArrayExtensionsTests.swift
//  Challenge-CitiesTests
//

import Testing
@testable import Challenge_Cities

/// Tests for Array+Extensions sortedAlphabetically.
struct ArrayExtensionsTests {

    @Test("Sorts strings alphabetically case-insensitively")
    func testSortedAlphabetically() async throws {
        let items = ["zebra", "Apple", "banana", "cherry"]
        let sorted = items.sortedAlphabetically(by: \.self)
        #expect(sorted == ["Apple", "banana", "cherry", "zebra"])
    }

    @Test("Handles empty array")
    func testEmptyArray() async throws {
        let items: [String] = []
        let sorted = items.sortedAlphabetically(by: \.self)
        #expect(sorted.isEmpty)
    }

    @Test("Handles single element")
    func testSingleElement() async throws {
        let items = ["Alpha"]
        let sorted = items.sortedAlphabetically(by: \.self)
        #expect(sorted == ["Alpha"])
    }

    @Test("Sorts by keyPath on custom type")
    func testSortByKeyPath() async throws {
        struct Item { let name: String }
        let items = [Item(name: "Z"), Item(name: "A"), Item(name: "M")]
        let sorted = items.sortedAlphabetically(by: \.name)
        #expect(sorted.map(\.name) == ["A", "M", "Z"])
    }
}
