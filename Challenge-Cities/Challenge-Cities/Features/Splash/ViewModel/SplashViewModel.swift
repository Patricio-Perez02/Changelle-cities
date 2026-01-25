//
//  SplashViewModel.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//
import Combine
import Foundation
@MainActor
final class SplashViewModel: ObservableObject {
    @Published var showCity = false
    @Published var showTitle = false
    @Published var pulseHalo = false
    @Published var isFinished: Bool = false
    
    init() {
    }
    
    func onAppear() {
        showCity = true
        pulseHalo = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            showTitle = true
        }
        
        Task {
            await setFinished()
        }
    }
    
    private func setFinished() async {
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            isFinished = true
        } catch {
            // Not used
        }
    }
}
