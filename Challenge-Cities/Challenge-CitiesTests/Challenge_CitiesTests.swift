//
//  Challenge_CitiesTests.swift
//  Challenge-CitiesTests
//
//  Created by Patricio Perez on 20/01/2026.
//

import Testing
@testable import Challenge_Cities

struct Challenge_CitiesTests {

    @Test("Test target loads and main module is accessible")
    func appLoads() async throws {
        #expect(City(country: "US", name: "Test", id: 1, coordinates: nil).fullName == "Test, US")
    }

}
