//
//  SettingsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.04.2026.
//

import SwiftUI
import SwiftData
import LocalAuthentication

struct SettingsView: View {
    
    @Environment(CouponService.self) private var couponService
    
    @AppStorage("defaultSport")
    private var defaultSport = Sports.football.rawValue
    @AppStorage("isFaceIDEnabled") private var isFaceIDEnabled = false
    
    @State private var isAlertPresented = false
    @State private var isErrorAlertPresented = false
    @State private var alertMessage: String?
    
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
                    .onChange(of: isFaceIDEnabled) {
                        if $1 {
                            enableFaceID()
                        }
                    }
                LabeledContent("Версия приложения") {
                    Text("1.0")
                }
            }
            Section("Данные") {
                Button("Очистить всю историю") {
                    isAlertPresented = true
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("Настройки")
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
                if success {
                    isFaceIDEnabled = true
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Coupon.self, Event.self)
    SettingsView()
        .modelContainer(container)
        .environment(CouponService(context: container.mainContext))
}
