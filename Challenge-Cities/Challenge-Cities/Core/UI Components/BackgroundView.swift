//
//  BackgroundView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue191, Color.blue82],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue217.opacity(0.35),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 220
                    )
                )
        }
    }
}
