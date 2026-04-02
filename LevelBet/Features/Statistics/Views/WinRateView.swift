//
//  WinRateView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 31.03.2026.
//

import SwiftUI

struct WinRateView: View {
    
    let coupons: [Coupon]
    
    var body: some View {
        NavigationStack {
            List {
                EventRangeSection()
                OddsRangeSection()
            }
            .background(Color.midnight)
            .scrollContentBackground(.hidden)
            .navigationTitle("Детальный винрейт (купоны)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func EventRangeSection() -> some View {
        Section("Кол-во событий") {
            ForEach(EventRange.allCases) {
                let winRate = ExtraMetricFactory.winRate(
                    for: coupons,
                    byEventRange: $0)
                if !winRate.isZero {
                    LabeledWinRate(title: $0.rawValue, value: winRate)
                }
            }
        }
    }
    
    private func OddsRangeSection() -> some View {
        Section("Диапазон коэф.") {
            ForEach(OddsRange.allCases) {
                let winRate = ExtraMetricFactory.winRate(
                    for: coupons,
                    byOddsRange: $0)
                if !winRate.isZero {
                    LabeledWinRate(title: $0.rawValue, value: winRate)
                }
            }
        }
    }
    
    private func LabeledWinRate(title: String, value: Double) -> some View {
        LabeledContent(title, value: value.fractionFormatted)
            .listRowBackground(Color(uiColor: .systemGroupedBackground))
    }
}
