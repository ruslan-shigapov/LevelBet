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
    
    private var uniqueDates: [Date] {
        Set(coupons.map { Calendar.current.startOfDay(for: $0.timestamp) })
            .sorted()
    }
    
    @Binding var selectedCoupon: Coupon?
    
    var body: some View {
        if coupons.isEmpty {
            ContentUnavailableView(
                "Нет купонов",
                systemImage: "ticket",
                description: Text(
                    "Чтобы добавить новый, коснись кнопки с плюсом выше."))
        } else {
            List {
                ForEach(uniqueDates, id: \.self) { date in
                    Section {
                        ForEach(getCoupons(by: date)) { coupon in
                            CouponView(coupon: coupon)
                                .onTapGesture {
                                    selectedCoupon = coupon
                                }
                                .swipeActions(
                                    edge: .trailing,
                                    allowsFullSwipe: false
                                ) {
                                    Button(role: .destructive) {
                                        withAnimation(.snappy) {
                                            couponService.delete(coupon)
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
        }
    }
    
    private func getCoupons(by date: Date) -> [Coupon] {
        coupons.filter {
            Calendar.current.isDate($0.timestamp, inSameDayAs: date)
        }
    }
}
