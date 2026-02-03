//
//  MockCitiesServices.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import Foundation
@testable import Challenge_Cities

/// Mock implementation of CitiesServicesProtocol and CityInformationServicesProtocol for testing
final class MockCitiesServices: CitiesServicesProtocol, CityInformationServicesProtocol {
    var citiesToReturn: [City] = []
    var shouldThrowError = false
    var errorToThrow: Error = NetworkError.invalidURL
    var getCitiesCallCount = 0
    var cityInformationToReturn: CityDetailInformation?
    var shouldThrowCityInfoError = false
    var getCityInformationCallCount = 0

    func getCities() async throws -> [City] {
        getCitiesCallCount += 1

        if shouldThrowError {
            throw errorToThrow
        }

        return citiesToReturn
    }

    func getCityInformation(with city: City) async throws -> CityDetailInformation? {
        getCityInformationCallCount += 1
        if shouldThrowCityInfoError {
            throw errorToThrow
        }
        return cityInformationToReturn
    }
}
