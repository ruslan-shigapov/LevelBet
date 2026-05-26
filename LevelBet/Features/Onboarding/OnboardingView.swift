//
//  OnboardingView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 25.05.2026.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var currentPage: OnboardingPage = .coupons
    
    let onFinish: () -> Void
    
    var body: some View {
        VStack(spacing: Layouts.largeOffset) {
            VStack(spacing: Layouts.smallOffset) {
                Image(systemName: currentPage.imageName)
                    .imageScale(.large)
                Text(currentPage.title)
                    .font(.title.weight(.medium))
                    .multilineTextAlignment(.center)
            }
            VStack(alignment: .leading, spacing: Layouts.standardOffset) {
                ForEach(currentPage.descriptions, id: \.self) {
                    Text($0)
                }
            }
            .foregroundStyle(.secondary)
            Button(currentPage.buttonTitle) {
                goNext()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, Layouts.largeOffset)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.midnight)
    }
    
    private func goNext() {
        switch currentPage {
        case .coupons:
            currentPage = .statistics
        case .statistics:
            currentPage = .profile
        case .profile: onFinish()
        }
    }
}
