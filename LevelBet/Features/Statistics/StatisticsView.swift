//
//  StatisticsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    
    // MARK: Private Properties
    @Query private var coupons: [Coupon]
    
    @State private var selectedPeriod: Periods = .week
    
    @State private var isInfoPresented = false
    @State private var isROIViewPresented = false
    @State private var isWinRateViewPresented = false
    @State private var isEventWinRateViewPresented = false
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
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
    
    // MARK: Body
    var body: some View {
        List {
            PeriodPicker()
            if !filtered.isEmpty {
                SummarySectionView(
                    filtered: filtered,
                    selectedPeriod: $selectedPeriod,
                    isROIViewPresented: $isROIViewPresented,
                    isWinRateViewPresented: $isWinRateViewPresented,
                    isEventWinRateViewPresented: $isEventWinRateViewPresented)
                AveragesSectionView(
                    metrics: AveragesFactory.make(for: filtered))
            }
        }
        .overlay(alignment: .center) {
            if filtered.isEmpty {
                EmptyState()
            }
        }
        .background(Color.lightMidnight)
        .toolbar { toolbarContent }
        .sheet(isPresented: $isInfoPresented) {
            InfoView()
        }
        .sheet(isPresented: $isROIViewPresented) {
            ModalMetricView(
                title: "Детальный ROI",
                content: ROIListView(coupons: filtered))
        }
        .sheet(isPresented: $isWinRateViewPresented) {
            ModalMetricView(
                title: "Детальный винрейт (купоны)",
                content: WinRateListView(coupons: filtered))
        }
        .sheet(isPresented: $isEventWinRateViewPresented) {
            ModalMetricView(
                title: "Детальный винрейт (события)",
                content: EventWinRateListView(coupons: filtered))
        }
    }
}

// MARK: - Views
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
    
    func EmptyState() -> some View {
        ContentUnavailableView {
            Label {
                Text("Нет данных")
            } icon: {
                Image(systemName: "graph.2d")
            }
        } description: {
            Text("""
            Добавь рассчитанные купоны или попробуй выбрать другой период.
            """)
        }
    }
}
