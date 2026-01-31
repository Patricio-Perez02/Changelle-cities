//
//  NetworkError.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError
    case invalidParameters
}
