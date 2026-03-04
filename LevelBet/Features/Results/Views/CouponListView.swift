//
//  CouponListView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI
import SwiftData

struct CouponListView: View {
    
    @Environment(CouponService.self) private var couponService
    
    @Query(sort: \Coupon.timestamp, order: .reverse)
    private var coupons: [Coupon]
    
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
    
    private var uniqueDates: [Date] {
        Set(filtered.map { Calendar.current.startOfDay(for: $0.timestamp) })
            .sorted()
    }
    
    let selectedPeriod: Periods
    let selectedStatus: Statuses
    
    @Binding var selectedCoupon: Coupon?
    
    var body: some View {
        if filtered.isEmpty {
            EmptyState()
        } else {
            List {
                ForEach(uniqueDates, id: \.self) { date in
                    Section {
                        ForEach(getCoupons(by: date)) { coupon in
                            CouponView(coupon: coupon)
                                .onTapGesture {
                                    selectedCoupon = coupon
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        withAnimation(.snappy) {
                                            delete(coupon)
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                        }
                    } header: {
                        Text(
                            date,
                            format: .dateTime.weekday(.wide).day().month())
                    }
                }
            }
            .errorAlert(message: $alertMessage, isPresented: $isAlertPresented)
        }
    }
    
    private func getCoupons(by date: Date) -> [Coupon] {
        filtered.filter {
            Calendar.current.isDate($0.timestamp, inSameDayAs: date)
        }
    }
    
    private func delete(_ coupon: Coupon) {
        do {
            try couponService.delete(coupon)
        } catch {
            alertMessage = (error as? DataError)?.description
            isAlertPresented = true
        }
    }
}

private extension CouponListView {
    
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
