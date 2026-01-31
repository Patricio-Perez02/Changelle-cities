//
//  CityMatcher.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

/// Utility responsible for finding the best matching `GeonamesCityData`
/// for a given `City`.
///
/// The matching strategy prioritizes:
/// 1. Country match (when available)
/// 2. Geographic proximity
/// 3. Exact name match
///
/// A lower score represents a better match.
enum CityMatcher {
    /// Finds the best matching `GeonamesCityData` for a given city.
    static func findBestMatch(for city: City, in geonames: [GeonamesCityData]) -> GeonamesCityData? {
        
        guard !geonames.isEmpty else { return nil }
        
        if geonames.count == 1 {
            return geonames.first
        }
        
        guard let normalizedCityName = city.name?.normalized() else {
            return nil
        }
        
        let candidates = filterByCountryIfPossible(city: city, geonames: geonames)
        
        return candidates.min {
            score(for: $0, cityName: normalizedCityName, cityCoordinates: city.coordinates) < score(for: $1, cityName: normalizedCityName, cityCoordinates: city.coordinates)
        }
    }
    
    // MARK: - Scoring
    /// Calculates a matching score for a GeoNames city candidate.
    private static func score(for geo: GeonamesCityData, cityName: String, cityCoordinates: CoordinatesData?) -> Double {
        var score: Double = 0
        
        score += distanceScore(geo: geo, cityCoordinates: cityCoordinates)
        
        score += nameScore(geo: geo, cityName: cityName)
        
        return score
    }
    
    // MARK: - Distance
    /// Computes the distance-based score component.
    private static func distanceScore(geo: GeonamesCityData, cityCoordinates: CoordinatesData?) -> Double {
        guard
            let lat = geo.lat.flatMap(Double.init),
            let lon = geo.lon.flatMap(Double.init),
            let cityCoords = cityCoordinates
        else {
            return Scoring.missingCoordinatesPenalty
        }
        
        let geoCoords = CoordinatesData(longitude: lon, latitude: lat)
        
        guard let distance = cityCoords.distance(to: geoCoords) else {
            return Scoring.missingCoordinatesPenalty
        }
        
        // Convert meters to kilometers
        return distance / 1_000
    }
    
    // MARK: - Name
    /// Computes the name-based score component.
    private static func nameScore(geo: GeonamesCityData, cityName: String) -> Double {
        guard let geoName = geo.name?.normalized() else {
            return Scoring.missingNamePenalty
        }
        
        return geoName == cityName ? 0 : Scoring.nameMismatchPenalty
    }
    
    // MARK: - Country filtering
    /// Filters candidates by country when possible.
    private static func filterByCountryIfPossible(city: City, geonames: [GeonamesCityData]) -> [GeonamesCityData] {
        guard let cityCountry = city.country?.normalized() else {
            return geonames
        }
        
        let filtered = geonames.filter {
            $0.countryName?.normalized() == cityCountry
        }
        
        return filtered.isEmpty ? geonames : filtered
    }
}

// MARK: - Scoring Constants
private enum Scoring {
    static let nameMismatchPenalty: Double = 500
    static let missingNamePenalty: Double = 1_000
    static let missingCoordinatesPenalty: Double = 10_000
}
