//
//  Endpoint.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import Foundation

/// Defines the requirements for a network endpoint.
///
/// An `EndpointProtocol` describes all the information needed to build a `URLRequest`,
/// including the URL, HTTP method, headers, query parameters, and request body.
protocol EndpointProtocol {
    // The endpoint base URL
    var baseURL: String { get }
    
    /// The endpoint path
    var path: String { get }
    
    /// The HTTP method used for the request (e.g. GET, POST).
    var method: HTTPMethod { get }
    
    /// Optional HTTP headers to be added to the request.
    var headers: [String: String]? { get }
    
    /// Optional query parameters appended to the URL.
    var queryItems: [URLQueryItem]? { get }
    
    /// Optional HTTP body data for the request.
    var body: Data? { get }
}

enum Endpoint: EndpointProtocol {
    private enum LocalConstants {
        static let geonamesUsernameParam = [URLQueryItem(name: "username", value: Constants.Envoirement.GEONAMES_USER)]
    }
    
    case cities
    case citySearch(lat: Double, lon: Double)
    case cityInformation(id: Int)
    
    var baseURL: String {
        switch self {
        case .cities:
            return Constants.Networking.CITIES_BASE_URL
        case .citySearch, .cityInformation:
            return Constants.Networking.GEONAMES_BASE_URL
        }
    }
    
    var path: String {
        switch self {
        case .cities:
            return "cities.json"
        case .citySearch:
            return "findNearbyJSON"
        case .cityInformation:
            return "getJSON"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .citySearch, .cities, .cityInformation:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .cities:
            return nil
        case .citySearch(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lng", value: "\(lon)")
            ] + LocalConstants.geonamesUsernameParam
        case .cityInformation(let id):
            return [
                URLQueryItem(name: "geonameId", value: "\(id)")
            ] + LocalConstants.geonamesUsernameParam
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .cities, .citySearch, .cityInformation:
            return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .cities, .citySearch, .cityInformation:
            return nil
        }
    }
}
