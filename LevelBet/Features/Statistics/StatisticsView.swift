//
//  StatisticsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    
    @Query private var coupons: [Coupon]
    
    @State private var isInfoPresented = false
    @State private var isROIDetailsPresented = false
    @State private var selectedPeriod: Periods = .week
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            ToolbarButton(type: .info) {
                isInfoPresented = true
            }
        }
    }
    
    private var filtered: [Coupon] {
        coupons.filter {
            FilterFactory.matches(coupon: $0, period: selectedPeriod)
        }
    }
    
    private var grouped: [Date: [Coupon]] {
        let calendar = Calendar.current
        return Dictionary(grouping: filtered) {
            let date = $0.timestamp
            return selectedPeriod == .year
            ? calendar.date(
                from: calendar.dateComponents(
                    [.year, .month],
                    from: date)) ?? date
            : calendar.startOfDay(for: date)
        }
    }
    
    private var sortedDates: [Date] {
        grouped.keys.sorted()
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
        .sheet(isPresented: $isInfoPresented) {}
        .sheet(isPresented: $isROIDetailsPresented) {
            ROIDetailsView(coupons: filtered)
                .presentationDragIndicator(.visible)
        }
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
            VStack {
                Chart {
                    ForEach(sortedDates, id: \.self) {
                        let profit = MetricFactory.profit(
                            for: grouped[$0] ?? [])
                        LineMark(
                            x: .value("", $0),
                            y: .value("",profit))
                        .foregroundStyle(.white.opacity(0.4))
                        PointMark(
                            x: .value("", $0),
                            y: .value("",profit))
                        .foregroundStyle(profit > 0 ? .green : .red)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: sortedDates) {
                        AxisGridLine()
                        AxisValueLabel(
                            format: selectedPeriod == .year
                            ? .dateTime.month(.abbreviated)
                            : .dateTime.day())
                    }
                }
                .padding(Layouts.smallOffset)
                LabeledContent("Профит") {
                    Text(metrics.profit.formatted())
                        .foregroundStyle(
                            metrics.profit < 0
                            ? .red
                            : metrics.profit > 0 ? .green : .secondary)
                }
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
                isROIDetailsPresented = true
            }
            LabeledContent(
                "Общая сумма",
                value: metrics.totalStake.formatted())
            LabeledContent(
                "Расчитанные купоны",
                value: metrics.settledCount.formatted())
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
                overall: metrics.stake.overall
                    .formatted(.number.precision(.fractionLength(0))),
                won: metrics.stake.won
                    .formatted(.number.precision(.fractionLength(0))),
                lost: metrics.stake.lost
                    .formatted(.number.precision(.fractionLength(0))))
            AveragesView(
                title: "Коэф. купона",
                overall: metrics.totalOdds.overall.oddsFormatted,
                won: metrics.totalOdds.won.oddsFormatted,
                lost: metrics.totalOdds.lost.oddsFormatted)
            AveragesView(
                title: "Коэф. события",
                overall: metrics.odds.overall.oddsFormatted,
                won: metrics.odds.won.oddsFormatted,
                lost: metrics.odds.lost.oddsFormatted)
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
