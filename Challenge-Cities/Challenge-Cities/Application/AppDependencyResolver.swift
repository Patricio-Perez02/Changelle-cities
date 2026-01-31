//
//  AppDependencyResolver.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

protocol AppDependencyResolverProtocol: AnyObject {
    var cities: CitiesDependencyResolverProtocol { get }
}

final class AppDependencyResolver: AppDependencyResolverProtocol {
    lazy var cities: CitiesDependencyResolverProtocol = {
        CitiesDependencyResolver()
    }()
}
