//
//  SplashView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = SplashViewModel()
    
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
                .scaleEffect(viewModel.pulseHalo ? 1.05 : 0.95)
                .opacity(viewModel.showCity ? 1 : 0)
                .animation(
                    .easeInOut(duration: 2).repeatForever(autoreverses: true),
                    value: viewModel.pulseHalo
                )
            
            VStack(spacing: 24) {
                Spacer()
                
                Image("appLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 260)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .scaleEffect(viewModel.showCity ? 1 : 0.95)
                    .opacity(viewModel.showCity ? 1 : 0)
                    .animation(.easeOut(duration: 0.45), value: viewModel.showCity)
                
                VStack(spacing: 8) {
                    Text("Cities")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(viewModel.showTitle ? 1 : 0)
                        .offset(y: viewModel.showTitle ? 0 : 10)
                        .animation(.easeOut(duration: 0.35), value: viewModel.showTitle)
                    
                    Text("Search your favorite city")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .opacity(viewModel.showTitle ? 1 : 0)
                        .animation(.easeOut.delay(0.1), value: viewModel.showTitle)
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: viewModel.isFinished) { _, newValue in
            if newValue {
                router.route(to: .cities(.search))
            }
        }
    }
}

#Preview {
    SplashView()
}
