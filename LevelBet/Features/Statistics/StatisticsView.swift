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
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            ToolbarButton(type: .info) {
                // TODO: show modal view
            }
        }
    }
    
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
                BreakdownSection(for: MetricFactory.averages(for: filtered))
            }
        }
        .overlay(alignment: .center) {
            if filtered.isEmpty {
                EmptyState()
            }
        }
        .background(Color.lightMidnight)
        .toolbar { toolbarContent }
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
            LabeledContent("Профит") {
                Text(metrics.profit.formatted())
                    .foregroundStyle(metrics.profit < 0
                        ? .red
                        : metrics.profit > 0 ? .green : .secondary)
            }
            LabeledContent {
                Text(format(fraction: metrics.roi))
                    .foregroundStyle(
                        metrics.roi < 0
                        ? .red
                        : metrics.roi > 0 ? .green : .secondary)
            } label: {
                HStack {
                    Text("ROI")
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .contentShape(.rect)
            .onTapGesture {
                // TODO: show modal view
            }
            LabeledContent(
                "Винрейт по купонам",
                value: format(fraction: metrics.winRate))
            LabeledContent(
                "Винрейт по событиям",
                value: format(fraction: metrics.eventWinRate))
        }
    }
    
    func BreakdownSection(for metrics: MetricFactory.Averages) -> some View {
        Section("Средние") {
            AveragesView(
                title: "Сумма",
                overall: metrics.stake.overall.formatted(),
                won: metrics.stake.won.formatted(),
                lost: metrics.stake.lost.formatted())
            AveragesView(
                title: "Коэф. купона",
                overall: metrics.totalOdds.overall
                    .formatted(.number.precision(.fractionLength(2))),
                won: metrics.totalOdds.won
                    .formatted(.number.precision(.fractionLength(2))),
                lost: metrics.totalOdds.lost
                    .formatted(.number.precision(.fractionLength(2))))
            AveragesView(
                title: "Коэф. события",
                overall: metrics.odds.overall
                    .formatted(.number.precision(.fractionLength(2))),
                won: metrics.odds.won
                    .formatted(.number.precision(.fractionLength(2))),
                lost: metrics.odds.lost
                    .formatted(.number.precision(.fractionLength(2))))
            AveragesView(
                title: "Кол-во событий",
                overall: metrics.eventCount.overall
                    .formatted(.number.precision(.fractionLength(0...1))),
                won: metrics.eventCount.won
                    .formatted(.number.precision(.fractionLength(0...1))),
                lost: metrics.eventCount.lost
                    .formatted(.number.precision(.fractionLength(0...1))))
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
