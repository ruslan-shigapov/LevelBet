//
//  EventWinRateListView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 01.04.2026.
//

import SwiftUI

struct EventWinRateListView: View {
    
    let coupons: [Coupon]
    
    var body: some View {
        List {
            OddsRangeSection()
            SportsSection()
        }
    }
}

private extension EventWinRateListView {
    
    func OddsRangeSection() -> some View {
        Section("Диапазон коэф.") {
            ForEach(EventOddsRange.allCases) {
                let winRate = ExtraMetricFactory.eventWinRate(
                    for: coupons,
                    byEventOddsRange: $0)
                if let winRate {
                    LabeledWinRateView(title: $0.rawValue, value: winRate)
                }
            }
        }
    }
    
    func SportsSection() -> some View {
        Section("Виды спорта") {
            ForEach(Sports.allCases) {
                let winRate = ExtraMetricFactory.eventWinRate(
                    for: coupons,
                    bySport: $0)
                if let winRate {
                    LabeledWinRateView(title: $0.rawValue, value: winRate)
                }
            }
        }
    }
}
