//
//  SearchableListFloatingView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import SwiftUI

struct SearchableCityFloatingView: View {
    private enum LocalConstants {
        static let itemBarHeight: CGFloat = 44.0
        static let rowHeight: CGFloat = 64.0
        static let heightMax: CGFloat = 350.0
    }
    
    let placeholder: String
    let cities: [City]
    @Binding var searchText: String
    @Binding var seletectedCity: City?
    @Binding var activeFilters: [CitiesFilter]
    let favoriteAction: (Int?) -> Void
    let navigationCityAction: (City) -> Void
    
    @State private var isExpanded: Bool = false
    @FocusState private var isFocused: Bool
    private var calculateListHeight: CGFloat {
        min(CGFloat(cities.count) * LocalConstants.rowHeight, LocalConstants.heightMax)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    
                    SearchCityBarView(
                        placeholder: placeholder,
                        searchText: $searchText,
                        isExpanded: $isExpanded,
                        activeFilters: $activeFilters,
                        isFocused: $isFocused
                    )
                    
                    if isFocused {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: .zero) {
                                ForEach(cities, id: \.id) { city in
                                    CityView(city: city, isFavourite: city.isFavorite, favoriteAction: favoriteAction, navigationAction: navigationCityAction)
                                        .frame(height: LocalConstants.rowHeight)
                                        .onTapGesture {
                                            seletectedCity = city
                                            searchText = city.fullName
                                            isExpanded = false
                                        }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .background(.ultraThinMaterial)
                .clipShape(
                    isExpanded ? AnyShape(RoundedRectangle(cornerRadius: 20)) : AnyShape(Circle())
                )
                .shadow(radius: 10)
                .padding(.horizontal)
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

#Preview {
    SearchableCityFloatingView(
        placeholder: "placeholder",
        cities: [],
        searchText: .constant("Test"),
        seletectedCity: .constant(nil),
        activeFilters: .constant([]),
        favoriteAction: { _ in },
        navigationCityAction: { _ in }
    )
}
