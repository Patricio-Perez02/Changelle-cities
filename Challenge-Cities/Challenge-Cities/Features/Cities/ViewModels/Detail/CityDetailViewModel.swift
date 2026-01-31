//
//  CityDetailViewModel.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

import Combine
import Foundation

@MainActor
final class CityDetailViewModel: ObservableObject {
    @Published private(set) var infomation: CityDetailInformation
    
    init(infomation: CityDetailInformation) {
        self.infomation = infomation
    }
}
