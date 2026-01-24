//
//  SearchCityBarView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 22/01/2026.
//

import SwiftUI

struct SearchCityBarView: View {
    private enum LocalConstants {
        static let barHeight: CGFloat = 44
    }
    
    let placeholder: String
    @Binding var searchText: String
    @Binding var isExpanded: Bool
    @Binding var activeFilters: [CitiesFilter]
    var isFocused: FocusState<Bool>.Binding
    
    private var favoriteApplied: Bool {
        activeFilters.contains(.favorites)
    }
    
    var body: some View {
        HStack(spacing: 16.0) {
            PillButton(image: isExpanded ? Image(systemName: "xmark") : Image(systemName: "magnifyingglass")) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                TextField(placeholder, text: $searchText)
                    .focused(isFocused)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                    )
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.async {
                            isFocused.wrappedValue = true
                        }
                    }
                    .onDisappear {
                        isFocused.wrappedValue = false
                    }
                
                PillButton(image: Image(systemName: "heart\(favoriteApplied ? ".fill" : "")")) {
                    toggle(.favorites)
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(height: LocalConstants.barHeight)
        .padding(10)
        .animation(.spring, value: isExpanded)
    }
    
    private func toggle(_ filter: CitiesFilter) {
        if let index = activeFilters.firstIndex(of: filter) {
            activeFilters.remove(at: index)
        } else {
            activeFilters.append(filter)
        }
    }
}
