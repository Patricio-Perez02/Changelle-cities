//
//  CityInformationServicesProtocol.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

/// Defines the interface for fetching detailed information
/// about a specific city.
protocol CityInformationServicesProtocol {
    /// Fetches detailed information for a given city.
    /// - Parameter city: The city used as reference to retrieve
    ///   its detailed information.
    /// - Returns: A `CityDetailInformation` instance if available,
    ///   or `nil` if no information could be found.
    /// - Throws: A `NetworkError` or data-related error if the request fails.
    func getCityInformation(with city: City) async throws -> CityDetailInformation?
}
