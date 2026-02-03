//
//  CityModelTests.swift
//  Challenge-CitiesTests
//

import Testing
@testable import Challenge_Cities

/// Tests for City and CoordinatesData models.
struct CityModelTests {

    @Test("City fullName combines name and country")
    func testCityFullName() async throws {
        let city = City(country: "USA", name: "New York", id: 1, coordinates: nil)
        #expect(city.fullName == "New York, USA")
    }

    @Test("City fullName handles nil values")
    func testCityFullNameWithNils() async throws {
        let city = City(country: nil, name: nil, id: 1, coordinates: nil)
        #expect(city.fullName == ", ")
    }

    @Test("CoordinatesData distance returns nil when coordinates missing")
    func testDistanceNilWhenMissingCoords() async throws {
        let a = CoordinatesData(longitude: nil, latitude: 40.7)
        let b = CoordinatesData(longitude: -74.0, latitude: 40.7)
        #expect(a.distance(to: b) == nil)
    }

    @Test("CoordinatesData distance calculates correctly")
    func testDistanceCalculation() async throws {
        let ny = CoordinatesData(longitude: -74.0, latitude: 40.7)
        let la = CoordinatesData(longitude: -118.2, latitude: 34.0)
        let distance = ny.distance(to: la)
        #expect(distance != nil)
        #expect(distance! > 3_900_000)
        #expect(distance! < 4_000_000)
    }

    @Test("CoordinatesData distance to self is zero")
    func testDistanceToSelf() async throws {
        let coord = CoordinatesData(longitude: -74.0, latitude: 40.7)
        #expect(coord.distance(to: coord) == 0)
    }
}
