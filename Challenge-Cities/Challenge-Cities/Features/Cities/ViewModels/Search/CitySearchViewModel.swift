//
//  CitySearchViewModel.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import Combine
import Foundation
import MapKit
import SwiftUI

@MainActor
final class CitySearchViewModel: ObservableObject {
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    private let trie = Trie<City>()
    private let services: CitiesServicesProtocol & CityInformationServicesProtocol
    private let storage: CitiesStorageProtocol
    
    // Cached dictionaries for O(1) lookups
    private var citiesById: [Int: City] = [:]
    private var favoriteStates: [Int: Bool] = [:]
    
    // MARK: - Public properties
    @Published var cities: [City] = [] {
        didSet {
            updateCachedDictionaries()
        }
    }
    
    @Published var route: CitiesRoutes?
    @Published var citiesSearchText: String = ""
    @Published var selectedPosition: MapCameraPosition = .automatic
    @Published private(set) var filteredCities: [City] = []
    @Published var activeFilters: [CitiesFilter] = []
    @Published var loadingMessage: String? = ""
    @Published var errorMessage: String?
    
    @Published var selectedCity: City? {
        didSet {
            updateSelectedCityPosition()
        }
    }
    
    // MARK: - Initialization
    
    init(
        services: CitiesServicesProtocol & CityInformationServicesProtocol,
        storage: CitiesStorageProtocol
    ) {
        self.services = services
        self.storage = storage
        bind()
    }
    
    // MARK: - Public methods
    
    /// Called when the view appears to fetch cities data
    func onAppear() {
        guard cities.isEmpty else { return }
        Task {
            await fetchCities()
        }
    }
    
    /// Toggles the favorite state of a city
    /// - Parameter cityId: The ID of the city to toggle
    func toggleFavorite(cityId: Int?) {
        guard let id = cityId else { return }
        
        let newFavoriteState = !storage.isFavorite(id: id)
        
        storage.toggle(id: id)
        favoriteStates[id] = newFavoriteState
        
        updateCityFavoriteState(cityId: id, isFavorite: newFavoriteState)
    }
    
    /// User requests more information about a city
    /// - Parameter city: The ID of the city for which more information is requested
    func cityMoreInfo(city: City?) {
        guard let city else { return }
        citiesSearchText = ""
        Task {
            loadingMessage = "Fetching information..."
            errorMessage = nil
            do {
                let response = try await services.getCityInformation(with: city)

                if let information = response {
                    route = .cityDetail(information: information)
                } else {
                    errorMessage = "No information found for this city."
                }
            } catch {
                errorMessage = "Failed to load city information. Please try again."
            }
            
            loadingMessage = nil
        }
    }
    
    // MARK: - Private methods
    /// Fetches cities from the service and updates the local state
    private func fetchCities() async {
        loadingMessage = "Loading cities..."
        errorMessage = nil
        
        do {
            let fetchedCities = try await services.getCities()
            
            fetchedCities.forEach { trie.insert(key: $0.fullName, value: $0) }
            
            let sortedCities = fetchedCities.sortedAlphabetically(by: \.fullName)
            let citiesWithFavorites = sortedCities.map { city -> City in
                var updatedCity = city
                let cityId = city.id ?? 0
                updatedCity.isFavorite = storage.isFavorite(id: cityId)
                return updatedCity
            }
            
            cities = citiesWithFavorites
            filteredCities = citiesWithFavorites
        } catch {
            errorMessage = "Failed to load cities. Please try again."
        }
        
        loadingMessage = nil
    }
    
    /// Sets up reactive bindings for search text and filters
    private func bind() {
        Publishers.CombineLatest(
            $citiesSearchText.removeDuplicates(),
            $activeFilters.removeDuplicates()
        )
        .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
        .sink { [weak self] searchText, activeFilters in
            self?.applySearchAndFilters(searchText: searchText, activeFilters: activeFilters)
        }
        .store(in: &cancellables)
    }
    
    /// Applies search text and filters to produce filtered results
    /// - Parameters:
    ///   - searchText: The text to search for
    ///   - activeFilters: The active filters to apply
    private func applySearchAndFilters(
        searchText: String,
        activeFilters: [CitiesFilter]
    ) {
        let baseResults: [City]
        
        if searchText.isEmpty {
            baseResults = cities
        } else {
            let searchResults = trie.search(prefix: searchText)
            baseResults = searchResults.map { searchedCity -> City in
                guard let id = searchedCity.id,
                      let isFavorite = favoriteStates[id] else {
                    return searchedCity
                }
                var updated = searchedCity
                updated.isFavorite = isFavorite
                return updated
            }
        }
        
        let filteredResults = applyFilters(activeFilters, to: baseResults)
        filteredCities = filteredResults.sortedAlphabetically(by: \.fullName)
    }
    
    /// Applies the given filters to the cities array
    /// - Parameters:
    ///   - filters: The filters to apply
    ///   - cities: The cities to filter
    /// - Returns: The filtered cities array
    private func applyFilters(
        _ filters: [CitiesFilter],
        to cities: [City]
    ) -> [City] {
        guard !filters.isEmpty else { return cities }
        
        return filters.reduce(into: cities) { partialResult, filter in
            switch filter {
            case .favorites:
                partialResult = partialResult.filter { $0.isFavorite }
                
            case .country(let country):
                partialResult = partialResult.filter { $0.country == country }
                
            case .coordinates(let lat, let lon):
                partialResult = partialResult.filter { city in
                    city.coordinates?.latitude == lat && 
                    city.coordinates?.longitude == lon
                }
            }
        }
    }
    
    /// Updates the favorite state of a specific city in both arrays
    /// - Parameters:
    ///   - cityId: The ID of the city to update
    ///   - isFavorite: The new favorite state
    private func updateCityFavoriteState(cityId: Int, isFavorite: Bool) {
        if var city = citiesById[cityId],
           let index = cities.firstIndex(where: { $0.id == cityId }) {
            city.isFavorite = isFavorite
            cities[index] = city
            citiesById[cityId] = city
        }
        
        if let index = filteredCities.firstIndex(where: { $0.id == cityId }) {
            var updatedCity = filteredCities[index]
            updatedCity.isFavorite = isFavorite
            filteredCities[index] = updatedCity
        }
    }
    
    /// Updates the cached dictionaries when cities array changes
    private func updateCachedDictionaries() {
        citiesById = Dictionary<Int, City>(
            uniqueKeysWithValues: cities.compactMap { city in
                guard let id = city.id else { return nil }
                return (id, city)
            }
        )
        
        favoriteStates = Dictionary<Int, Bool>(
            uniqueKeysWithValues: cities.compactMap { city in
                guard let id = city.id else { return nil }
                return (id, city.isFavorite)
            }
        )
    }
    
    /// Updates the map position when a city is selected
    private func updateSelectedCityPosition() {
        guard let city = selectedCity,
              let coordinates = city.coordinates,
              let latitude = coordinates.latitude,
              let longitude = coordinates.longitude else {
            return
        }
        
        let center = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        selectedPosition = .region(MKCoordinateRegion(center: center, span: span))
    }
}
