//
//  ROIListView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 05.04.2026.
//

import SwiftUI

struct ROIListView: View {
    
    let coupons: [Coupon]
    
    var body: some View {
        List {
            EventRangeSection()
            OddsRangeSection()
        }
    }
}

private extension ROIListView {
    
    func EventRangeSection() -> some View {
        Section("Кол-во событий") {
            ForEach(EventRange.allCases) {
                let roi = ExtraMetricFactory.roi(for: coupons, byEventRange: $0)
                if !roi.isZero {
                    LabeledROI(title: $0.rawValue, value: roi)
                }
            }
        }
    }
    
    func OddsRangeSection() -> some View {
        Section("Диапазон коэф.") {
            ForEach(OddsRange.allCases) {
                let roi = ExtraMetricFactory.roi(for: coupons, byOddsRange: $0)
                if !roi.isZero {
                    LabeledROI(title: $0.rawValue, value: roi)
                }
            }
        }
    }
    
    func LabeledROI(title: String, value: Double) -> some View {
        LabeledContent(title) {
            Text(value.fractionFormatted)
                .foregroundStyle(value < 0 ? .red : .green)
        }
        .listRowBackground(Color(uiColor: .systemGroupedBackground))
    }
}
