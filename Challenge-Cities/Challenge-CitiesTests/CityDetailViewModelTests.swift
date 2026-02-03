//
//  CityDetailViewModelTests.swift
//  Challenge-CitiesTests
//

import Testing
@testable import Challenge_Cities

/// Tests for CityDetailViewModel - displays city detail information.
@MainActor
struct CityDetailViewModelTests {

    func makeDetailInfo() -> CityDetailInformation {
        CityDetailInformation(
            id: 1,
            name: "Paris",
            countryName: "France",
            population: 2_100_000,
            countryCode: "FR",
            continentCode: "EU",
            lat: "48.86",
            lon: "2.35",
            region1: "Île-de-France",
            region2: "Paris",
            wikipediaURL: "https://en.wikipedia.org/wiki/Paris"
        )
    }

    @Test("Initializes with provided information")
    func testInitialization() async throws {
        let info = makeDetailInfo()
        let viewModel = CityDetailViewModel(infomation: info)
        #expect(viewModel.infomation.name == "Paris")
        #expect(viewModel.infomation.countryName == "France")
        #expect(viewModel.infomation.population == 2_100_000)
    }

    @Test("Holds reference to detail information")
    func testInformationPersistence() async throws {
        let info = CityDetailInformation(name: "London", countryName: "United Kingdom")
        let viewModel = CityDetailViewModel(infomation: info)
        #expect(viewModel.infomation.name == "London")
        #expect(viewModel.infomation.countryName == "United Kingdom")
    }
}
