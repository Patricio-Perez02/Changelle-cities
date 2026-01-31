//
//  CitySearchServicesProtocol.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 30/01/2026.
//

/// Defines the interface for searching a city using
/// geographic or identifying data.
protocol CitySearchServicesProtocol {
    /// Searches for a city using the provided city reference.
    /// - Parameter coordinate: A city reference containing
    ///   the data needed to perform the search.
    /// - Returns: A `GeonamesCityData` instance if a match is found,
    ///   or `nil` if no results are available.
    /// - Throws: A `NetworkError` if the request fails.
    func searchCity(from coordinate: City) async throws -> GeonamesCityData?
}
