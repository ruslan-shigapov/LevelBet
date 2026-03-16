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
                MainSection()
            }
        }
        .overlay(alignment: .center) {
            if filtered.isEmpty {
                EmptyState()
            }
        }
        .background(Color.lightMidnight)
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
    
    func MainSection() -> some View {
        Section("Сводка") {
            LabeledContent(
                "Расчитанные купоны",
                value: String(MetricFactory.settledCount(for: filtered)))
            LabeledContent(
                "Чистая прибыль",
                value: String(MetricFactory.profit(for: filtered)))
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
