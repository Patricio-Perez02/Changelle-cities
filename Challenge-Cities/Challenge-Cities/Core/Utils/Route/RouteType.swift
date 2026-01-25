//
//  Route.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import Foundation

enum RoutePath: Hashable {
    case splash
    case citySearch
    case cityDetail(id: Int)
}
