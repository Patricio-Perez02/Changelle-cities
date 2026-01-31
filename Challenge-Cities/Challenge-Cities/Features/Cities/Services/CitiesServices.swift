//
//  CitiesServices.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import Combine

final class CitiesServices: CitiesServicesProtocol, CitySearchServicesProtocol, CityInformationServicesProtocol {
    // MARK: - Private properties
    private let networkingManager: NetworkingManagerProtocol
    
    // MARK: - Initialization
    /// Creates a new cities service.
    ///
    /// - Parameter networkingManager: The networking manager to use.
    ///   Defaults to `NetworkingManager`.
    init(
        networkingManager: NetworkingManagerProtocol = NetworkingManager()
    ) {
        self.networkingManager = networkingManager
    }
    
    // MARK: - CitiesServiciesProtocol methods
    func getCities() async throws -> [City] {
        try await networkingManager.request(Endpoint.cities)
    }
    
    // MARK: - CitySearchServicesProtocol methods
    func searchCity(from city: City) async throws -> GeonamesCityData? {
        guard let lat = city.coordinates?.latitude, let lon = city.coordinates?.longitude else {
            return nil
        }
        
        let response: GeonamesResponse = try await networkingManager.request(Endpoint.citySearch(lat: lat, lon: lon))
        
        return CityMatcher.findBestMatch(for: city, in: response.geonames)
    }
    
    // MARK: - CityInformationServicesProtocol
    func getCityInformation(with city: City) async throws -> CityDetailInformation? {
        let geonamesCityData: GeonamesCityData? = try await searchCity(from: city)
        
        guard let geonamesCityData, let id = geonamesCityData.id else {
            return nil
        }
        
        let response: CityDetailInformation = try await networkingManager.request(Endpoint.cityInformation(id: id))
        return response
    }
}

