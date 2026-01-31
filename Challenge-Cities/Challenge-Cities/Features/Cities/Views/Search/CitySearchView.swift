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
                    if let city = viewModel.selectedCity,
                       let lat = city.coordinates?.latitude,
                       let lon = city.coordinates?.longitude {
                        Marker(
                            city.fullName,
                            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        )
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
                
                if let message = viewModel.loadingMessage {
                    LoadingView(text: message)
                }
            }
            .onAppear(perform: viewModel.onAppear)
            .toolbar(.hidden, for: .navigationBar)
            .onChange(of: viewModel.route) { _, route in
                guard let route else { return }
                router.route(to: .cities(route))
                viewModel.route = nil
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
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
