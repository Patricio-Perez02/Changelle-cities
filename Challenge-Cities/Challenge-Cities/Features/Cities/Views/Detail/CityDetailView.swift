//
//  CityDetailView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

import SwiftUI
import Combine
import _MapKit_SwiftUI

struct CityDetailView: View {
    @StateObject var viewModel: CityDetailViewModel

    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.infomation.name ?? "City")
                            .font(.title)
                            .fontWeight(.bold)

                        if let country = viewModel.infomation.countryName, let code = viewModel.infomation.countryCode {
                            Text(code.flagEmoji() + " " + country)
                                .font(.subheadline)
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let population = viewModel.infomation.population {
                        InfoRow(icon: Image(systemName: "person.2.fill"), title: "Population", value: "\(population)")
                    }
                    
                    if let region1 = viewModel.infomation.region1, let region2 = viewModel.infomation.region2 {
                        InfoRow(icon: Image(systemName: "building.2.fill"), title: "Region", value: "\(region1)  \(region2)")
                    }
                    
                    if let latitude = viewModel.infomation.lat, let longitude = viewModel.infomation.lon,
                       let lat = Double(latitude), let lon = Double(longitude) {
                        
                        InfoRow(icon: Image(systemName: "map.fill"), title: "Location", value: "\(latitude), \(longitude)")
                        
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        let region = MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                        
                        Map(initialPosition: .region(region)) {
                            Marker("", coordinate: coordinate)
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

#Preview {
    CityDetailView(
        viewModel: CityDetailViewModel(
            infomation: CityDetailInformation(lat: "-24.666",lon: "35.0555")
        )
    )
}
