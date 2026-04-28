//
//  SettingsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.04.2026.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("defaultSport")
    private var defaultSport = Sports.football.rawValue
    
    @AppStorage("isFaceIDEnabled") private var isFaceIDEnabled = false
    
    var body: some View {
        Form {
            Section("Главное") {
                Picker("Вид спорта по умолч.", selection: $defaultSport) {
                    ForEach(Sports.allCases) {
                        Text($0.rawValue)
                            .tag($0.rawValue)
                    }
                }
                Toggle("Вход по Face ID", isOn: $isFaceIDEnabled)
                LabeledContent("Версия приложения") {
                    Text("1.0")
                }
            }
            Section("Данные") {
                Button("Очистить всё") {
                    
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("Настройки")
    }
}

#Preview {
    SettingsView()
}
