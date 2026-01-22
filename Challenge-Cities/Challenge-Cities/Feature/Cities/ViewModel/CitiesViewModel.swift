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
        
        Task {
            await fetchCities()
        }
        
        bind()
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
        $citiesSearchText
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] text in
                guard let self, !text.isEmpty else {
                    return self?.cities.sortedAlphabetically(by: \.fullName) ?? []
                }
                
                let results = trie.search(prefix: text)
                let sorted = results.sortedAlphabetically(by: \.fullName)
                return sorted
            }
            .receive(on: RunLoop.main)
            .assign(to: &$filteredCities)
    }
}
