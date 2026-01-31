//
//  City.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import CoreLocation

struct City: Identifiable, Codable {
    let country: String?
    let name: String?
    let id: Int?
    let coordinates: CoordinatesData?
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coordinates = "coord"
    }
    
    var fullName: String {
        return "\(name ?? ""), \(country ?? "")"
    }
    
    var isFavorite: Bool = false
}

struct CoordinatesData: Codable {
    let longitude, latitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
    
    /// Helper
    func distance(to other: CoordinatesData) -> CLLocationDistance? {
        guard
            let lat1 = latitude,
            let lon1 = longitude,
            let lat2 = other.latitude,
            let lon2 = other.longitude else { return nil }

        let loc1 = CLLocation(latitude: lat1, longitude: lon1)
        let loc2 = CLLocation(latitude: lat2, longitude: lon2)
        return loc1.distance(from: loc2)
    }
}
