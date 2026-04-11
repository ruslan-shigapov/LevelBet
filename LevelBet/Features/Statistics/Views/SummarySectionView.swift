//
//  SummarySectionView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 05.04.2026.
//

import SwiftUI
import Charts

struct SummarySectionView: View {
    
    // MARK: Private Properties
    private var metrics: Summary {
        SummaryFactory.make(for: filtered)
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
    
    // MARK: Public Properties
    let filtered: [Coupon]
    
    @Binding var selectedPeriod: Periods
    
    @Binding var isROIViewPresented: Bool
    @Binding var isWinRateViewPresented: Bool
    @Binding var isEventWinRateViewPresented: Bool
    
    // MARK: Body
    var body: some View {
        Section("Сводка") {
            ProfitStack()
            ROIRow()
            LabeledContent("Общая сумма", value: metrics.totalStake.formatted())
            LabeledContent(
                "Расчитанные купоны",
                value: metrics.settledCount.formatted())
            WinRateRow(
                title: "Винрейт (купоны)",
                value: metrics.winRate,
                isModalViewPresented: $isWinRateViewPresented)
            WinRateRow(
                title: "Винрейт (события)",
                value: metrics.eventWinRate,
                isModalViewPresented: $isEventWinRateViewPresented)
        }
    }
}

// MARK: - Views
private extension SummarySectionView {
    
    func ProfitStack() -> some View {
        VStack {
            Chart {
                ForEach(sortedDates, id: \.self) {
                    let profit = ExtraMetricFactory.profit(
                        for: grouped[$0] ?? [])
                    LineMark(x: .value("", $0), y: .value("",profit))
                        .foregroundStyle(.white.opacity(0.4))
                    PointMark(x: .value("", $0), y: .value("",profit))
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
    }
    
    func ROIRow() -> some View {
        LabeledContent {
            Text(metrics.roi.fractionFormatted)
                .foregroundStyle(
                    metrics.roi < 0
                    ? .red
                    : metrics.roi > 0 ? .green : .secondary)
        } label: {
            ChevronLabel(title: "ROI")
        }
        .contentShape(.rect)
        .onTapGesture {
            isROIViewPresented = true
        }
    }
    
    func ChevronLabel(title: String) -> some View {
        HStack {
            Text(title)
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundStyle(Color.accentColor)
        }
    }
    
    func WinRateRow(
        title: String,
        value: Double,
        isModalViewPresented: Binding<Bool>
    ) -> some View {
        LabeledContent {
            Text(value.fractionFormatted)
        } label: {
            ChevronLabel(title: title)
        }
        .contentShape(.rect)
        .onTapGesture {
            isModalViewPresented.wrappedValue = true
        }
    }
}
