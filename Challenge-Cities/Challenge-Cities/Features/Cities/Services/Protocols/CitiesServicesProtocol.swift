//
//  CitiesServicesProtocol.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 30/01/2026.
//

/// Defines the interface for fetching city-related data.
protocol CitiesServicesProtocol {
    /// Fetches the list of cities.
    ///
    /// - Returns: An array of `City` models.
    /// - Throws: A `NetworkError` if the request fails.
    func getCities() async throws -> [City]
}
