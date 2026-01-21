//
//  City.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

struct City: Codable {
    let country: String?
    let name: String?
    let id: Int?
    let coordinates: CoordinatesData?
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coordinates = "coord"
    }
}

struct CoordinatesData: Codable {
    let longitude, latitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
