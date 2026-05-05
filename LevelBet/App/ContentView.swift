//
//  ContentView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import LocalAuthentication

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

    @AppStorage("isFaceIDEnabled") private var isFaceIDEnabled = false
    
    @State private var selectedTab: Tabs = .profile
    
    var body: some View {
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
            }
        }
        .onAppear {
            if isFaceIDEnabled {
                authenticate()
            }
        }
    }
    
    private func authenticate() {
        let context = LAContext()
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Разблокируйте приложние."
        ) { success, _ in
            Task { @MainActor in
                if success {
                    isFaceIDEnabled = true
                }
            }
        }
    }
}
