//
//  CityDetailInformation.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

struct CityDetailInformation: Codable, Equatable, Hashable {
    let id: Int?
    let name: String?
    let countryName: String?
    let population: Int?
    let continentCode: String?
    let lat, lon: String?
    let region1, region2: String?
    let wikipediaURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "geonameId"
        case name, countryName, population, continentCode, lat
        case lon = "lng"
        case region1 = "adminName1"
        case region2 = "adminName2"
        case wikipediaURL
    }
    
    /// Use for preview or i need use in declarations.
    init(
        id: Int? = nil,
        name: String? = nil,
        countryName: String? = nil,
        population: Int? = nil,
        continentCode: String? = nil,
        lat: String? = nil,
        lon: String? = nil,
        region1: String? = nil,
        region2: String? = nil,
        wikipediaURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.countryName = countryName
        self.population = population
        self.continentCode = continentCode
        self.lat = lat
        self.lon = lon
        self.region1 = region1
        self.region2 = region2
        self.wikipediaURL = wikipediaURL
    }
}
