//
//  CityMatcherTests.swift
//  Challenge-CitiesTests
//

import Testing
@testable import Challenge_Cities

/// Tests for CityMatcher utility - finds best GeonamesCityData match for a City.
@MainActor
struct CityMatcherTests {

    func makeCity(name: String?, country: String?, coordinates: CoordinatesData?) -> City {
        City(
            country: country,
            name: name,
            id: 1,
            coordinates: coordinates
        )
    }

    func makeGeonames(name: String?, countryName: String?, lat: String?, lon: String?) -> GeonamesCityData {
        GeonamesCityData(
            lat: lat,
            lon: lon,
            id: 1,
            population: nil,
            name: name,
            countryName: countryName
        )
    }

    @Test("Returns nil when geonames is empty")
    func testEmptyGeonames() async throws {
        let city = makeCity(name: "Paris", country: "France", coordinates: CoordinatesData(longitude: 2.3, latitude: 48.9))
        #expect(CityMatcher.findBestMatch(for: city, in: []) == nil)
    }

    @Test("Returns single result when only one geonames entry")
    func testSingleGeonamesEntry() async throws {
        let city = makeCity(name: "Paris", country: "France", coordinates: CoordinatesData(longitude: 2.3, latitude: 48.9))
        let geo = makeGeonames(name: "Paris", countryName: "France", lat: "48.9", lon: "2.3")
        let result = CityMatcher.findBestMatch(for: city, in: [geo])
        #expect(result?.name == "Paris")
    }

    @Test("Returns nil when city has no name")
    func testCityWithNilName() async throws {
        let city = makeCity(name: nil, country: "France", coordinates: CoordinatesData(longitude: 2.3, latitude: 48.9))
        let geo = makeGeonames(name: "Paris", countryName: "France", lat: "48.9", lon: "2.3")
        #expect(CityMatcher.findBestMatch(for: city, in: [geo]) == nil)
    }

    @Test("Prefers match with same country when multiple candidates")
    func testCountryMatch() async throws {
        let city = makeCity(name: "London", country: "United Kingdom", coordinates: CoordinatesData(longitude: -0.1, latitude: 51.5))
        let londonUK = makeGeonames(name: "London", countryName: "United Kingdom", lat: "51.5", lon: "-0.1")
        let londonCanada = GeonamesCityData(lat: "42.98", lon: "-81.24", id: 2, population: nil, name: "London", countryName: "Canada")
        let geonames = [londonUK, londonCanada]
        let result = CityMatcher.findBestMatch(for: city, in: geonames)
        #expect(result?.countryName == "United Kingdom")
    }

    @Test("Prefers geographically closer match when names differ")
    func testProximityPreference() async throws {
        let city = makeCity(name: "Springfield", country: "USA", coordinates: CoordinatesData(longitude: -93.3, latitude: 37.2))
        let near = GeonamesCityData(lat: "37.21", lon: "-93.3", id: 1, population: nil, name: "Springfield", countryName: "USA")
        let far = GeonamesCityData(lat: "39.78", lon: "-89.65", id: 2, population: nil, name: "Springfield", countryName: "USA")
        let geonames = [far, near]
        let result = CityMatcher.findBestMatch(for: city, in: geonames)
        #expect(result?.id == 1)
    }

    @Test("Handles diacritics and case in city name matching")
    func testNormalizedNameMatching() async throws {
        let city = makeCity(name: "Zürich", country: "Switzerland", coordinates: CoordinatesData(longitude: 8.5, latitude: 47.4))
        let geo = GeonamesCityData(lat: "47.37", lon: "8.54", id: 1, population: nil, name: "Zurich", countryName: "Switzerland")
        let result = CityMatcher.findBestMatch(for: city, in: [geo])
        #expect(result?.name == "Zurich")
    }
}
