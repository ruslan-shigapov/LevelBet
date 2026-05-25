//
//  OnboardingView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 25.05.2026.
//

import SwiftUI

struct OnboardingView: View {
    
    let onFinish: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("LevelBet")
                .font(.largeTitle.bold())
            Text("Отслеживайте купоны, анализируйте результаты и контролируйте дисциплину.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Начать") {
                onFinish()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    OnboardingView {}
}
