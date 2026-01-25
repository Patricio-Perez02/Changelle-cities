//
//  MockCitiesServices.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import Foundation
@testable import Challenge_Cities

/// Mock implementation of CitiesServicesProtocol for testing
final class MockCitiesServices: CitiesServicesProtocol {
    var citiesToReturn: [City] = []
    var shouldThrowError = false
    var errorToThrow: Error = NetworkError.invalidURL
    var getCitiesCallCount = 0
    
    func getCities() async throws -> [City] {
        getCitiesCallCount += 1
        
        if shouldThrowError {
            throw errorToThrow
        }
        
        return citiesToReturn
    }
}
