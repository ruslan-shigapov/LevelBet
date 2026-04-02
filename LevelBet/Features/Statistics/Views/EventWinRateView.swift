//
//  EventWinRateView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 01.04.2026.
//

import SwiftUI

struct EventWinRateView: View {
    
    let coupons: [Coupon]
    
    var body: some View {
        NavigationStack {
            List {
                OddsRangeSection()
                SportsSection()
            }
            .background(Color.midnight)
            .scrollContentBackground(.hidden)
            .navigationTitle("Детальный винрейт (события)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func OddsRangeSection() -> some View {
        Section("Диапазон коэф.") {
            ForEach(EventOddsRange.allCases) {
                let winRate = ExtraMetricFactory.eventWinRate(
                    for: coupons,
                    byEventOddsRange: $0)
                if !winRate.isZero {
                    LabeledWinRate(title: $0.rawValue, value: winRate)
                }
            }
        }
    }
    
    private func SportsSection() -> some View {
        Section("Виды спорта") {
            ForEach(Sports.allCases) {
                let winRate = ExtraMetricFactory.eventWinRate(
                    for: coupons,
                    bySport: $0)
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
