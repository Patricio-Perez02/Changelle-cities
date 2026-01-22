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

    /// The endpoint URL.
    /// Returns `nil` if the URL cannot be constructed.
    var url: URL? { get }

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
    case cities
    
    var url: URL? {
        switch self {
        case .cities:
            URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .cities:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .cities:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .cities:
            return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .cities:
            return nil
        }
    }
}
