//
//  CitiesViewModel.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import Combine
import Foundation
import MapKit
import SwiftUI

@MainActor
final class CitiesViewModel: ObservableObject {
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    private let trie = Trie<City>()
    private let services: CitiesServicesProtocol
    
    // MARK: - Public properties
    @Published var cities: [City] = []
    @Published var citiesSearchText: String = ""
    @Published var selectedPosition: MapCameraPosition = .automatic
    @Published private(set) var filteredCities: [City] = []
    @Published private(set) var favoriteCityIDs: Set<Int> = []
    @Published var activeFilters: [CitiesFilter] = []
    @Published var selectedCity: City? {
        didSet {
            guard let city = selectedCity, let coordinates = city.coordinates else { return }
            let center = CLLocationCoordinate2D(
                latitude: coordinates.latitude ?? 0.0,
                longitude: coordinates.longitude ?? 0.0
            )
            
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            selectedPosition = .region(MKCoordinateRegion(center: center, span: span))
            filteredCities = []
        }
    }
    // MARK: - Initialization
    
    init(
        services: CitiesServicesProtocol
    ) {
        self.services = services
        bind()
    }
    
    // MARK: - Public methods
    func onAppear() {
        Task {
            await fetchCities()
        }
    }
    
    func toggleFavorite(cityId: Int?) {
        guard let id = cityId else { return }
        
        if favoriteCityIDs.contains(id) {
            favoriteCityIDs.remove(id)
        } else {
            favoriteCityIDs.insert(id)
        }
        
        updateCitiesFavoriteState()
    }
    
    // MARK: - Private methods
    private func fetchCities() async {
        do {
            cities = try await self.services.getCities()
            cities.forEach { trie.insert(key: $0.fullName, value: $0) }
            filteredCities = cities.sortedAlphabetically(by: \.fullName)
        } catch {
            // TODO: - Screen view?
            debugPrint("Error fetching cities: \(String(describing: error))")
        }
    }
    
    private func bind() {
        Publishers.CombineLatest($citiesSearchText, $activeFilters)
                .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
                .sink { [weak self] _, _ in
                    self?.applySearchAndFilters()
                }
                .store(in: &cancellables)
    }
    
    private func applySearchAndFilters() {
        let searchResults = citiesSearchText.isEmpty ? cities : trie.search(prefix: citiesSearchText)
        
        filteredCities = applyFilters(to: searchResults).sortedAlphabetically(by: \.fullName)
    }
    
    private func applyFilters(to cities: [City]) -> [City] {
        return activeFilters.reduce(into: cities) { partialResult, filter in
            switch filter {
            case .favorites:
                partialResult = partialResult.filter { $0.isFavorite }

            case .country(let country):
                partialResult = partialResult.filter { $0.country == country }

            case .coordinates(let lat, let lon):
                partialResult = partialResult.filter { $0.coordinates?.latitude == lat && $0.coordinates?.longitude == lon }
            }
        }
    }
    
    private func updateCitiesFavoriteState() {
        cities = applyingFavorites(to: cities)
        filteredCities = applyingFavorites(to: filteredCities)
    }
    
    private func applyingFavorites(to cities: [City]) -> [City] {
        cities.map { city in
            guard let id = city.id else { return city }

            var updated = city
            updated.isFavorite = favoriteCityIDs.contains(id)
            return updated
        }
    }
}
