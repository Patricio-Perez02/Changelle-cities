//
//  CitiesServices.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import Combine

/// Defines the interface for fetching city-related data.
protocol CitiesServicesProtocol {
    /// Fetches the list of cities.
    ///
    /// - Returns: An array of `City` models.
    /// - Throws: A `NetworkError` if the request fails.
    func getCities() async throws -> [City]
}

final class CitiesServices: CitiesServicesProtocol {
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
        try await networkingManager.request(.cities)
    }
}
