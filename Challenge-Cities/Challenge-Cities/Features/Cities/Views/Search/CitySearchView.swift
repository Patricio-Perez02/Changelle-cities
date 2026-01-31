//
//  CitiesView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import SwiftUI
import MapKit

struct CitySearchView: View {
    @EnvironmentObject private var router: AppRouter
    @StateObject var viewModel: CitySearchViewModel
    
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
                            viewModel.cityMoreInfo(city: city)
                        }
                    )
                    .frame(maxWidth: isLandscape ? geometry.size.width / 2 : .infinity, alignment: .leading)
                    .padding(.top)
                    
                    if isLandscape {
                        Spacer()
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView(text: "Loading cities...")
                }
            }
            .onAppear(perform: viewModel.onAppear)
            .toolbar(.hidden, for: .navigationBar)
            .onChange(of: viewModel.route) { _, route in
                guard let route else { return }
                router.route(to: .cities(route))
                viewModel.route = nil
            }
        }
    }
}

#Preview {
    CitySearchView(
        viewModel: CitySearchViewModel(
            services: CitiesServices(),
            storage: CitiesStorage()
        )
    )
}
