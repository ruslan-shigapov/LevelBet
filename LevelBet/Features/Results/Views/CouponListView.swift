//
//  CouponListView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI
import SwiftData

struct CouponListView: View {
    
    // MARK: Private Properties
    @Environment(CouponService.self) private var couponService
    
    @Query(sort: \Coupon.timestamp, order: .reverse)
    private var coupons: [Coupon]
    
    @State private var selectedStatus = Statuses.all
    @State private var alertMessage: String?
    @State private var isAlertPresented = false

    private var filtered: [Coupon] {
        coupons.filter {
            FilterFactory.matches(
                coupon: $0,
                period: selectedPeriod,
                status: selectedStatus)
        }
    }
    
    private var grouped: [Date: [Coupon]] {
        Dictionary(grouping: filtered) {
            Calendar.current.startOfDay(for: $0.timestamp)
        }
    }
    
    private var sortedDates: [Date] {
        grouped.keys.sorted(by: >)
    }
    
    // MARK: Public Properties
    let selectedPeriod: Periods
    
    @Binding var selectedCoupon: Coupon?
    
    // MARK: Body
    var body: some View {
        List {
            StatusBarView(selectedStatus: $selectedStatus)
                .listRowInsets(.init())
                .listRowBackground(Color.clear)
            ForEach(sortedDates, id: \.self) { date in
                Section {
                    ForEach(grouped[date] ?? []) { coupon in
                        CouponView(coupon: coupon)
                            .onTapGesture {
                                selectedCoupon = coupon
                            }
                            .swipeActions(edge: .trailing) {
                                DeleteSwipeButton {
                                    delete(coupon)
                                }
                            }
                    }
                } header: {
                    SectionHeader(for: date, coupons: grouped[date] ?? [])
                }
            }
        }
        .overlay(alignment: .center) {
            if filtered.isEmpty {
                EmptyState()
            }
        }
        .errorAlert(message: $alertMessage, isPresented: $isAlertPresented)
    }
    
    // MARK: Private Methods
    private func delete(_ coupon: Coupon) {
        do {
            try couponService.delete(coupon)
        } catch {
            alertMessage = (error as? DataError)?.description
            isAlertPresented = true
        }
    }
    
    private func formatProfit(_ profit: Int) -> String {
        profit.formatted(.number.sign(strategy: .always()))
    }
}

// MARK: - Views
private extension CouponListView {
    
    func SectionHeader(for date: Date, coupons: [Coupon]) -> some View {
        LabeledContent {
            ProfitText(ExtraMetricFactory.profit(for: coupons))
        } label: {
            Text(date, format: .dateTime.weekday(.wide).day().month())
        }
        .fontWeight(.semibold)
    }
    
    func ProfitText(_ profit: Int) -> some View {
        Text(profit.formatted(.number.sign(strategy: .automatic)))
            .foregroundStyle(
                profit < 0 ? .red : profit > 0 ? .green : .secondary)
    }
    
    func EmptyState() -> some View {
        ContentUnavailableView {
            Label {
                Text("Нет купонов")
            } icon: {
                Image(systemName: "ticket")
            }
        } description: {
            Text(
                coupons.isEmpty
                ? "Чтобы добавить новый, коснись кнопки с плюсом выше."
                : "Попробуй выбрать другой период или статус.")
        }
    }
}
