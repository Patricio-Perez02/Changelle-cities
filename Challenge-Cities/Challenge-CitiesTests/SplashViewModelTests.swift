//
//  SplashViewModelTests.swift
//  Challenge-CitiesTests
//

import Testing
@testable import Challenge_Cities

/// Tests for SplashViewModel - splash screen timing and state.
@MainActor
struct SplashViewModelTests {

    @Test("Initial state is correct")
    func testInitialState() async throws {
        let viewModel = SplashViewModel()
        #expect(!viewModel.showCity)
        #expect(!viewModel.showTitle)
        #expect(!viewModel.pulseHalo)
        #expect(!viewModel.isFinished)
    }

    @Test("onAppear sets showCity and pulseHalo immediately")
    func testOnAppearImmediateState() async throws {
        let viewModel = SplashViewModel()
        viewModel.onAppear()
        #expect(viewModel.showCity)
        #expect(viewModel.pulseHalo)
    }

    @Test("onAppear sets showTitle after delay")
    func testOnAppearShowTitle() async throws {
        let viewModel = SplashViewModel()
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 400_000_000)
        #expect(viewModel.showTitle)
    }

    @Test("onAppear sets isFinished after splash duration")
    func testOnAppearIsFinished() async throws {
        let viewModel = SplashViewModel()
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 2_500_000_000)
        #expect(viewModel.isFinished)
    }
}
