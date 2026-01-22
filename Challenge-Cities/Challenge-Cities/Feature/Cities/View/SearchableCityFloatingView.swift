//
//  SearchableListFloatingView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 20/01/2026.
//

import SwiftUI

struct SearchableCityFloatingView: View {
    private enum LocalConstants {
        static let rowHeight: CGFloat = 44.0
        static let heightMax: CGFloat = 350.0
    }
    
    let placeholder: String
    @Binding var cities: [City]
    @Binding var searchText: String
    @Binding var seletectedCity: City?
    
    @FocusState private var isFocused: Bool
    private var calculateListHeight: CGFloat {
        min(CGFloat(cities.count) * LocalConstants.rowHeight, LocalConstants.heightMax)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: .zero) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .foregroundStyle(.gray.opacity(0.75))
                        .scaledToFit()
                        .padding(.vertical, 15)
                        .padding(.horizontal, 10)
                    
                    TextField(placeholder, text: $searchText)
                        .focused($isFocused)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(.thinMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
                .frame(height: LocalConstants.rowHeight)
                .padding(10)
                
                if isFocused {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: .zero) {
                            ForEach(cities, id: \.id) { city in
                                Text(city.fullName)
                                    .frame(height: LocalConstants.rowHeight)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        seletectedCity = city
                                        searchText = city.fullName
                                        isFocused = false
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)
                    .frame(height: calculateListHeight)
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            .shadow(radius: 10)
            .padding(.horizontal)
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    SearchableCityFloatingView(
        placeholder: "placeholder",
        cities: .constant([]),
        searchText: .constant("Test"),
        seletectedCity: .constant(nil)
    )
}
