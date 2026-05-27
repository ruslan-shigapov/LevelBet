//
//  ContentView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import LocalAuthentication
import SwiftData

// MARK: Tabs
private enum Tabs: String, CaseIterable, Identifiable {
    
    case results = "Результаты"
    case statistics = "Статистика"
    case profile = "Профиль"
    
    var imageName: String {
        switch self {
        case .results: "flag.2.crossed"
        case .statistics: "chart.bar"
        case .profile: "person.crop.rectangle"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .results: ResultsView()
        case .statistics: StatisticsView()
        case .profile: ProfileView()
        }
    }
    
    var id: Self { self }
}

struct ContentView: View {

    // MARK: Private Properties
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("isFaceIDEnabled") private var isFaceIDEnabled = false
    @AppStorage("isOnboardingShown") private var isOnboardingShown = false
    
    @State private var selectedTab: Tabs = .results
    @State private var isUnlocked = false
    
    private var shouldAuthenticate: Bool {
        isFaceIDEnabled && !isUnlocked
    }
    
    // MARK: Body
    var body: some View {
        Group {
            if !isOnboardingShown {
                OnboardingView {
                    isOnboardingShown = true
                }
            } else {
                MainView()
                    .overlay {
                        if shouldAuthenticate {
                            LockView()
                        }
                    }
                    .onAppear {
                        if shouldAuthenticate {
                            authenticate()
                        }
                    }
                    .onChange(of: scenePhase) {
                        if scenePhase != .active && isFaceIDEnabled {
                            isUnlocked = false
                        }
                    }
            }
        }
    }
    
    // MARK: Private Methods
    private func authenticate() {
        let context = LAContext()
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Разблокируйте приложение."
        ) { success, _ in
            Task { @MainActor in
                isUnlocked = success
            }
        }
    }
}

// MARK: - Views
private extension ContentView {
    
    func LockView() -> some View {
        VStack(spacing: Layouts.standardOffset) {
            VStack(spacing: Layouts.smallOffset) {
                Image(systemName: "faceid")
                    .font(.largeTitle)
                Text("Приложение под защитой")
                    .font(.headline)
            }
            Button("Разблокировать") {
                authenticate()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.midnight)
    }
    
    func MainView() -> some View {
        TabView(selection: $selectedTab) {
            ForEach(Tabs.allCases) { tab in
                NavigationStack {
                    tab.view
                        .navigationTitle(tab.rawValue)
                        .scrollContentBackground(.hidden)
                        .background(.thinMaterial)
                }
                .tabItem {
                    Label(tab.rawValue, systemImage: tab.imageName)
                }
                .tag(tab)
            }
        }
    }
}
