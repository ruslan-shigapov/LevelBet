//
//  ROIView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 25.03.2026.
//

import SwiftUI

struct ROIView: View {
    
    let coupons: [Coupon]
    
    var body: some View {
        NavigationStack {
            List {
                EventRangeSection()
                OddsRangeSection()
            }
            .background(Color.midnight)
            .scrollContentBackground(.hidden)
            .navigationTitle("Детальный ROI")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func EventRangeSection() -> some View {
        Section("Кол-во событий") {
            ForEach(EventRange.allCases) {
                let roi = ExtraMetricFactory.roi(for: coupons, byEventRange: $0)
                if !roi.isZero {
                    LabeledROI(title: $0.rawValue, value: roi)
                }
            }
        }
    }
    
    private func OddsRangeSection() -> some View {
        Section("Диапазон коэф.") {
            ForEach(OddsRange.allCases) {
                let roi = ExtraMetricFactory.roi(for: coupons, byOddsRange: $0)
                if !roi.isZero {
                    LabeledROI(title: $0.rawValue, value: roi)
                }
            }
        }
    }
    
    private func LabeledROI(title: String, value: Double) -> some View {
        LabeledContent(title) {
            Text(value.fractionFormatted)
                .foregroundStyle(value < 0 ? .red : .green)
        }
        .listRowBackground(Color(uiColor: .systemGroupedBackground))
    }
}
