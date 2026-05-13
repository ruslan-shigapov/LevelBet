//
//  SettingsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.04.2026.
//

import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    
    // MARK: Private Properties
    @Environment(CouponService.self) private var couponService
    
    @AppStorage("defaultSport")
    private var defaultSport = Sports.football.rawValue
    @AppStorage("isFaceIDEnabled") private var isFaceIDEnabled = false
    
    @State private var isAlertPresented = false
    @State private var isErrorAlertPresented = false
    @State private var alertMessage: String?
    
    // MARK: Body
    var body: some View {
        Form {
            MainSection()
            DataSection()
        }
        .navigationTitle("Настройки")
        .scrollContentBackground(.hidden)
        .background(Color.lightMidnight)
        .alert("Вы уверены?", isPresented: $isAlertPresented) {
            Button("Нет", role: .cancel) {}
            Button("Да", role: .destructive) {
                do {
                    try couponService.deleteAll()
                } catch {
                    alertMessage = (error as? DataError)?.description
                    isErrorAlertPresented = true
                }
            }
        } message: {
            Text("Все купоны будут удалены безвозвратно.")
        }
        .errorAlert(
            message: $alertMessage,
            isPresented: $isErrorAlertPresented)
    }
    
    // MARK: Private Methods
    private func enableFaceID() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            isFaceIDEnabled = false
            return
        }
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Подтвердите вход по Face ID."
        ) { success, _ in
            Task { @MainActor in
                isFaceIDEnabled = success
            }
        }
    }
}

// MARK: - Views
private extension SettingsView {
    
    func MainSection() -> some View {
        Section("Главное") {
            Picker("Вид спорта по умолч.", selection: $defaultSport) {
                ForEach(Sports.allCases) {
                    Text($0.rawValue)
                        .tag($0.rawValue)
                }
            }
            Toggle("Вход по Face ID", isOn: $isFaceIDEnabled)
                .onChange(of: isFaceIDEnabled) {
                    if $1 {
                        enableFaceID()
                    }
                }
            LabeledContent("Версия приложения") {
                Text("1.0")
            }
        }
    }
    
    func DataSection() -> some View {
        Section("Данные") {
            Button("Очистить всю историю") {
                isAlertPresented = true
            }
            .foregroundStyle(.red)
        }
    }
}
