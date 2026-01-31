//
//  CityDetailView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

import SwiftUI

struct CityDetailView: View {
    @StateObject var viewModel: CityDetailViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CityDetailView(
        viewModel: CityDetailViewModel(
            infomation: CityDetailInformation()
        )
    )
}
