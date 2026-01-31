//
//  RootView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import SwiftUI

struct RootView: View {
    let resolver: AppDependencyResolverProtocol
    @StateObject private var router = AppRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            SplashView()
                .navigationDestination(for: RoutePath.self) { route in
                    switch route {
                    case .splash:
                        SplashView()
                        
                    case .cities(let routes):
                        switch routes {
                        case .search:
                            let viewModel = resolver.cities.makeCitySearchViewModel()
                            CitySearchView(viewModel: viewModel)
                            
                        case .cityDetail(let information):
                            let viewModel = resolver.cities.makeCityDetailViewModel(information: information)
                            CityDetailView(viewModel: viewModel)
                        }
                    }
                }
        }
        .environmentObject(router)
    }
}
