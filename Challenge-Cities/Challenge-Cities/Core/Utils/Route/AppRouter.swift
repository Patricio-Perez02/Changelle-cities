//
//  AppRouter.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import Foundation
import Combine
import SwiftUI

class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func route(to: RoutePath) {
        path.append(to)
    }
    
    func reset() {
        path = NavigationPath()
        route(to: .splash)
    }
}
