//
//  Challenge_CitiesApp.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import SwiftUI

@main
struct Challenge_CitiesApp: App {
    private let resolver: AppDependencyResolverProtocol = AppDependencyResolver()
    var body: some Scene {
        WindowGroup {
            RootView(resolver: resolver)
        }
    }
}
