//
//  StatisticsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    
    @Query private var coupons: [Coupon]
    
    @State private var selectedPeriod: Periods = .week
    
    private var filtered: [Coupon] {
        coupons.filter {
            FilterFactory.matches(coupon: $0, period: selectedPeriod)
        }
    }
    
    var body: some View {
        List {
            PeriodPicker()
            if !filtered.isEmpty {
                SummarySection(for: MetricFactory.summary(for: filtered))
                BreakdownSection()
            }
        }
        .overlay(alignment: .center) {
            if filtered.isEmpty {
                EmptyState()
            }
        }
        .background(Color.lightMidnight)
    }
    
    private func format(fraction: Double) -> String {
        fraction.formatted(.percent.precision(.fractionLength(0...1)))
    }
}

private extension StatisticsView {
    
    func PeriodPicker() -> some View {
        Picker("", selection: $selectedPeriod) {
            ForEach(Periods.allCases) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .listRowInsets(.init())
        .listRowBackground(Color.clear)
    }
    
    func SummarySection(for metrics: MetricFactory.Summary) -> some View {
        Section("Сводка") {
            LabeledContent(
                "Расчитанные купоны",
                value: metrics.settledCount.formatted())
            LabeledContent(
                "Общая сумма",
                value: metrics.totalStake.formatted())
            LabeledContent(
                "Профит",
                value: metrics.profit.formatted())
            LabeledContent(
                "ROI",
                value: format(fraction: metrics.roi))
            LabeledContent(
                "Винрейт",
                value: format(fraction: metrics.winRate))
        }
    }
    
    func BreakdownSection() -> some View {
        Section("Срезы") {
            
        }
    }
    
    func EmptyState() -> some View {
        ContentUnavailableView {
            Label {
                Text("Нет данных")
            } icon: {
                Image(systemName: "graph.2d")
            }
        } description: {
            Text("Добавь рассчитанные купоны или попробуй выбрать другой период.")
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Coupon.self, Event.self)
    ContentView()
        .modelContainer(container)
        .environment(CouponService(context: container.mainContext))
}
