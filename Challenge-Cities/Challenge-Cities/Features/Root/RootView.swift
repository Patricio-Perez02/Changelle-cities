//
//  RootView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            SplashView()
                .navigationDestination(for: RoutePath.self) { route in
                    switch route {
                    case .splash:
                        SplashView()

                    case .citySearch:
                        CitySearchView()

                    case .cityDetail:
                        // TODO: Create city detail
                        SplashView()
                    }
                }
        }
        .environmentObject(router)
    }
}
