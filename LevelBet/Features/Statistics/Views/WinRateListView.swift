//
//  WinRateListView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 31.03.2026.
//

import SwiftUI

struct WinRateListView: View {
    
    let coupons: [Coupon]
    
    var body: some View {
        List {
            EventRangeSection()
            OddsRangeSection()
        }
    }
}

private extension WinRateListView {
    
    func EventRangeSection() -> some View {
        Section("Кол-во событий") {
            ForEach(EventRange.allCases) {
                let winRate = ExtraMetricFactory.winRate(
                    for: coupons,
                    byEventRange: $0)
                if !winRate.isZero {
                    LabeledWinRateView(title: $0.rawValue, value: winRate)
                }
            }
        }
    }
    
    func OddsRangeSection() -> some View {
        Section("Диапазон коэф.") {
            ForEach(OddsRange.allCases) {
                let winRate = ExtraMetricFactory.winRate(
                    for: coupons,
                    byOddsRange: $0)
                if !winRate.isZero {
                    LabeledWinRateView(title: $0.rawValue, value: winRate)
                }
            }
        }
    }
}
