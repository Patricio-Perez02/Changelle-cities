//
//  CitiesView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import SwiftUI
import MapKit

struct CitySearchView: View {
    @StateObject private var viewModel = CitySearchViewModel(
        services: CitiesServices(),
        storage: CitiesStorage()
    )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Map(position: $viewModel.selectedPosition) {
                    if let selectedCity = viewModel.selectedCity,
                       let center = viewModel.selectedPosition.region?.center {
                        Marker(selectedCity.fullName, coordinate: center)
                    }
                }
                .ignoresSafeArea()
                
                let isLandscape = geometry.size.width > geometry.size.height
                HStack {
                    SearchableCityFloatingView(
                        placeholder: "Search city",
                        cities: viewModel.filteredCities,
                        searchText: $viewModel.citiesSearchText,
                        seletectedCity: $viewModel.selectedCity,
                        activeFilters: $viewModel.activeFilters,
                        favoriteAction: { id in
                            viewModel.toggleFavorite(cityId: id)
                        }, navigationCityAction: { city in
                            print("City: \(city.fullName) selected")
                        }
                    )
                    .frame(maxWidth: isLandscape ? geometry.size.width / 2 : .infinity, alignment: .leading)
                    .padding(.top)
                    
                    if isLandscape {
                        Spacer()
                    }
                }
            }
            .onAppear(perform: viewModel.onAppear)
        }
    }
}

#Preview {
    CitySearchView()
}
