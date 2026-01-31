//
//  NetworkingManager.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import Foundation

/// Defines a generic networking interface for performing HTTP requests.
///
/// Conforming types are responsible for executing network requests and
/// decoding the response into the expected `Decodable` model.
protocol NetworkingManagerProtocol {
    /// Performs a network request for the given endpoint and decodes the response.
    ///
    /// - Parameter endpoint: The endpoint describing the request configuration.
    /// - Returns: A decoded model of type `T`.
    /// - Throws: A `NetworkError` if the request fails or decoding fails.
    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T
}

final class NetworkingManager: NetworkingManagerProtocol {
    // MARK: - Private properties
    private let session: URLSession
    
    // MARK: - Initialization
    /// Creates a new networking manager.
    ///
    /// - Parameter session: The URLSession instance to use. Defaults to `.shared`.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - NetwokingManagerProtocol methods
    func request<T>(_ endpoint: EndpointProtocol) async throws -> T where T : Decodable {
        var components = URLComponents(string: endpoint.baseURL)
        components?.path += endpoint.path
        components?.queryItems = endpoint.queryItems
        
        guard let finalURL = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        endpoint.headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
