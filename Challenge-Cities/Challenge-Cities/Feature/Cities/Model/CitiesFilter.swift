//
//  CitiesFilter.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 22/01/2026.
//

enum CitiesFilter: Hashable {
    case favorites
    case country(String)
    case coordinates(lat: Double, lon: Double)
}
