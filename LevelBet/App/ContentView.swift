//
//  ContentView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI

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

    var body: some View {
        TabView {
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
    }
}
