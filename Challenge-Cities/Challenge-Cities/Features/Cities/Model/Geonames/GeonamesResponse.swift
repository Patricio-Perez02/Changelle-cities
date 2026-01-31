//
//  GeonamesResponse.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 30/01/2026.
//

struct GeonamesResponse: Codable {
    let geonames: [GeonamesCityData]
}

struct GeonamesCityData: Codable {
    let lat, lon: String?
    let id: Int?
    let population: Int?
    let name, countryName: String?
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon = "lng"
        case id = "geonameId"
        case population
        case name
        case countryName
    }
}
