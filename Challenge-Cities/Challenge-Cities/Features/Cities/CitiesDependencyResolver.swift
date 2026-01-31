//
//  CitiesDependecyResolver.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

/// Protocol responsible for resolving and providing dependencies
/// related to the Cities feature.
///
/// This resolver centralizes the creation of ViewModels,
/// ensuring that all required services and storage dependencies
/// are properly injected.
protocol CitiesDependencyResolverProtocol {
    /// Creates and returns a `CitySearchViewModel`.
    ///
    /// The returned ViewModel is configured with the necessary
    /// services and storage needed to perform city searches
    /// and persist related data.
    ///
    /// - Returns: A fully configured `CitySearchViewModel`.
    func makeCitySearchViewModel() -> CitySearchViewModel
    
    /// Creates and returns a `CityDetailViewModel`.
    ///
    /// This ViewModel is initialized with the information
    /// required to display detailed data about a specific city.
    ///
    /// - Parameter information: A model containing the data
    ///   needed to build the city detail screen.
    /// - Returns: A `CityDetailViewModel` configured with the provided information.
    func makeCityDetailViewModel(information: CityDetailInformation) -> CityDetailViewModel
}

final class CitiesDependencyResolver: CitiesDependencyResolverProtocol {
    // MARK: - Private properties
    private lazy var services: CitiesServicesProtocol & CitySearchServicesProtocol & CityInformationServicesProtocol = {
        return CitiesServices()
    }()
    
    private lazy var storage: CitiesStorageProtocol = {
        return CitiesStorage()
    }()
    
    // MARK: - CitiesDependencyResolver
    func makeCitySearchViewModel() -> CitySearchViewModel {
        CitySearchViewModel(services: services, storage: storage)
    }
    
    func makeCityDetailViewModel(information: CityDetailInformation) -> CityDetailViewModel {
        CityDetailViewModel(infomation: information)
    }
}
