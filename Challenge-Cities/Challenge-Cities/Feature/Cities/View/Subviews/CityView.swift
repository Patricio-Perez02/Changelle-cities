//
//  CityView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 22/01/2026.
//

import SwiftUI

struct CityView: View {
    let city: City
    let isFavourite: Bool
    let favoriteAction: (Int?) -> Void
    let navigationAction: (City) -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: .zero) {
                Text(city.fullName)
                    .font(.headline)
                
                if let coordinates = city.coordinates, let latitude = coordinates.latitude, let longitude = coordinates.longitude {
                    Text("\(latitude), \(longitude)")
                        .font(.footnote)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center, spacing: 8) {
                Button {
                    favoriteAction(city.id)
                } label: {
                    Image(systemName: "heart\(isFavourite ? ".fill" : "")")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.pink)
                }
                
                Button {
                    navigationAction(city)
                } label: {
                    Text("More info")
                        .font(.system(size: 12, weight: .semibold, design: .default))
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(Color.clear)
    }
}

#Preview {
    CityView(
        city: City(
            country: "AR",
            name: "La Tablada",
            id: 1424,
            coordinates: CoordinatesData(
                longitude: 2030,
                latitude: 2323
            )
        ),
        isFavourite: true,
        favoriteAction: { _ in },
        navigationAction: { _ in }
    )
}
