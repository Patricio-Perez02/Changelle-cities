//
//  CitiesView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import SwiftUI
import MapKit

struct CitiesView: View {
    @StateObject private var viewModel = CitiesViewModel(services: CitiesServices())
    
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
                
                if geometry.size.width > geometry.size.height {
                    getListLandscape(width: geometry.size.width)
                } else {
                    getListPortrait()
                }
            }
        }
    }
    
    var searchableList: some View {
        SearchableCityFloatingView(
            placeholder: "",
            cities: .constant(viewModel.filteredCities),
            searchText: $viewModel.citiesSearchText,
            seletectedCity: $viewModel.selectedCity
        )
    }
    
    func getListLandscape(width: CGFloat) -> some View {
        HStack {
            searchableList
            .frame(width: width / 2)
            
            Spacer()
        }
        .padding(.top)
    }
    
    func getListPortrait() -> some View {
        VStack {
            Spacer()
            
            searchableList
        }
        .padding(.top)
    }
}

#Preview {
    CitiesView()
}
