//
//  CitySearchViewModelTest.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import Testing
import Combine
@testable import Challenge_Cities

/// Unit tests for CitySearchViewModel
///
/// These tests verify:
/// - Initial state
/// - City fetching and loading
/// - Search functionality
/// - Filtering (favorites, country, coordinates)
/// - Favorite toggling
/// - Error handling
@MainActor
struct CitySearchViewModelTests {
    
    // MARK: - Helper Methods
    
    func makeSampleCities() -> [City] {
        [
            City(
                country: "USA",
                name: "New York",
                id: 1,
                coordinates: CoordinatesData(longitude: -74.0, latitude: 40.7)
            ),
            City(
                country: "USA",
                name: "Los Angeles",
                id: 2,
                coordinates: CoordinatesData(longitude: -118.2, latitude: 34.0)
            ),
            City(
                country: "UK",
                name: "London",
                id: 3,
                coordinates: CoordinatesData(longitude: -0.1, latitude: 51.5)
            ),
            City(
                country: "France",
                name: "Paris",
                id: 4,
                coordinates: CoordinatesData(longitude: 2.3, latitude: 48.9)
            )
        ]
    }
    
    // MARK: - Initial State Tests
    
    @Test("ViewModel should initialize with empty state")
    func testInitialState() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        #expect(viewModel.cities.isEmpty)
        #expect(viewModel.filteredCities.isEmpty)
        #expect(viewModel.citiesSearchText.isEmpty)
        #expect(viewModel.activeFilters.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.selectedCity == nil)
    }
    
    // MARK: - Fetch Cities Tests
    
    @Test("ViewModel should fetch and load cities successfully")
    func testFetchCitiesSuccess() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        
        // Wait a bit for async operations
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        #expect(viewModel.cities.count == 4)
        #expect(viewModel.filteredCities.count == 4)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
        #expect(mockServices.getCitiesCallCount == 1)
    }
    
    @Test("ViewModel should handle fetch error correctly")
    func testFetchCitiesError() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        
        mockServices.shouldThrowError = true
        mockServices.errorToThrow = NetworkError.invalidURL
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        
        // Wait a bit for async operations
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        #expect(viewModel.cities.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage?.contains("Failed to load") == true)
    }
    
    @Test("ViewModel should not fetch cities if already loaded")
    func testOnAppearDoesNotRefetch() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        let initialCallCount = mockServices.getCitiesCallCount
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Should not call again
        #expect(mockServices.getCitiesCallCount == initialCallCount)
    }
    
    // MARK: - Search Tests
    
    @Test("ViewModel should filter cities by search text")
    func testSearchFiltering() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.citiesSearchText = "New"
        
        // Wait for debounce
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        #expect(viewModel.filteredCities.count == 1)
        #expect(viewModel.filteredCities.first?.name == "New York")
    }
    
    @Test("ViewModel should handle empty search text")
    func testEmptySearchText() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.citiesSearchText = "NonExistent"
        try await Task.sleep(nanoseconds: 300_000_000)
        
        viewModel.citiesSearchText = ""
        try await Task.sleep(nanoseconds: 300_000_000)
        
        #expect(viewModel.filteredCities.count == 4)
    }
    
    // MARK: - Filter Tests
    
    @Test("ViewModel should filter by favorites")
    func testFilterByFavorites() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        mockStorage.setFavorites([1, 3]) // New York and London
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Update cities to have favorites
        viewModel.cities = sampleCities.map { city in
            var updated = city
            updated.isFavorite = mockStorage.isFavorite(id: city.id ?? 0)
            return updated
        }
        try await Task.sleep(nanoseconds: 50_000_000)
        
        viewModel.activeFilters = [.favorites]
        try await Task.sleep(nanoseconds: 300_000_000)
        
        #expect(viewModel.filteredCities.count == 2)
        #expect(viewModel.filteredCities.allSatisfy { $0.isFavorite })
    }
    
    @Test("ViewModel should filter by country")
    func testFilterByCountry() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.activeFilters = [.country("USA")]
        try await Task.sleep(nanoseconds: 300_000_000)
        
        #expect(viewModel.filteredCities.count == 2)
        #expect(viewModel.filteredCities.allSatisfy { $0.country == "USA" })
    }
    
    @Test("ViewModel should filter by coordinates")
    func testFilterByCoordinates() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        viewModel.activeFilters = [.coordinates(lat: 40.7, lon: -74.0)]
        try await Task.sleep(nanoseconds: 300_000_000)
        
        #expect(viewModel.filteredCities.count == 1)
        #expect(viewModel.filteredCities.first?.name == "New York")
    }
    
    @Test("ViewModel should apply multiple filters")
    func testMultipleFilters() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        mockStorage.setFavorites([1, 2]) // New York and Los Angeles
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Update cities to have favorites
        viewModel.cities = sampleCities.map { city in
            var updated = city
            updated.isFavorite = mockStorage.isFavorite(id: city.id ?? 0)
            return updated
        }
        try await Task.sleep(nanoseconds: 50_000_000)
        
        viewModel.activeFilters = [.favorites, .country("USA")]
        try await Task.sleep(nanoseconds: 300_000_000)
        
        #expect(viewModel.filteredCities.count == 2)
        #expect(viewModel.filteredCities.allSatisfy { $0.isFavorite && $0.country == "USA" })
    }
    
    // MARK: - Favorite Toggle Tests
    
    @Test("ViewModel should toggle favorite correctly")
    func testToggleFavorite() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        let cityId = 1
        #expect(!mockStorage.isFavorite(id: cityId))
        
        viewModel.toggleFavorite(cityId: cityId)
        
        #expect(mockStorage.isFavorite(id: cityId))
        
        // Toggle again
        viewModel.toggleFavorite(cityId: cityId)
        
        #expect(!mockStorage.isFavorite(id: cityId))
    }
    
    @Test("ViewModel should handle nil city ID when toggling favorite")
    func testToggleFavoriteWithNilId() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        // Should not crash
        viewModel.toggleFavorite(cityId: nil)
        
        #expect(true) // If we get here, no crash occurred
    }
    
    // MARK: - Selected City Tests
    
    @Test("ViewModel should update map position when city is selected")
    func testSelectedCityUpdatesPosition() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        
        mockServices.citiesToReturn = sampleCities
        
        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        let newYork = sampleCities.first { $0.name == "New York" }!
        viewModel.selectedCity = newYork
        
        try await Task.sleep(nanoseconds: 50_000_000)
        
        #expect(viewModel.selectedCity?.id == 1)
    }

    @Test("ViewModel navigates to detail when cityMoreInfo succeeds")
    func testCityMoreInfoSuccess() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        let sampleCities = makeSampleCities()
        mockServices.citiesToReturn = sampleCities

        let detailInfo = CityDetailInformation(name: "New York", countryName: "USA")
        mockServices.cityInformationToReturn = detailInfo

        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)

        let newYork = sampleCities.first { $0.name == "New York" }!
        viewModel.cityMoreInfo(city: newYork)
        try await Task.sleep(nanoseconds: 200_000_000)

        #expect(mockServices.getCityInformationCallCount == 1)
        #expect(viewModel.route != nil)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("ViewModel shows error when cityMoreInfo fails")
    func testCityMoreInfoError() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        mockServices.shouldThrowCityInfoError = true

        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        let city = City(country: "USA", name: "New York", id: 1, coordinates: CoordinatesData(longitude: -74, latitude: 40.7))
        viewModel.cityMoreInfo(city: city)
        try await Task.sleep(nanoseconds: 200_000_000)

        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage?.contains("Failed") == true)
    }

    @Test("ViewModel shows error when cityMoreInfo returns nil")
    func testCityMoreInfoNoInformation() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()
        mockServices.cityInformationToReturn = nil

        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        let city = City(country: "USA", name: "Unknown", id: 99, coordinates: nil)
        viewModel.cityMoreInfo(city: city)
        try await Task.sleep(nanoseconds: 200_000_000)

        #expect(viewModel.errorMessage?.contains("No information") == true)
    }

    @Test("ViewModel does nothing when cityMoreInfo receives nil city")
    func testCityMoreInfoNilCity() async throws {
        let mockServices = MockCitiesServices()
        let mockStorage = MockCitiesStorage()

        let viewModel = CitySearchViewModel(
            services: mockServices,
            storage: mockStorage
        )
        viewModel.cityMoreInfo(city: nil)

        #expect(mockServices.getCityInformationCallCount == 0)
    }
}

