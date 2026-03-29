//
//  CouponView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI

struct CouponView: View {
    
    private let eventsCount: Int
    private let totalStatus: Statuses
    private let stake: String
    private let totalOdds: String
    private let winnings: String
    
    let coupon: Coupon
    
    init(coupon: Coupon) {
        self.coupon = coupon
        totalOdds = coupon.totalOdds.oddsFormatted
        eventsCount = coupon.events.count
        totalStatus = coupon.totalStatus
        stake = coupon.stake.formatted()
        winnings = coupon.winnings.formatted()
    }
    
    var body: some View {
        VStack(spacing: Layouts.mediumOffset) {
            HStack {
                TypeText()
                Spacer()
                StatusImage()
            }
            SummaryStack()
        }
        .contentShape(.rect)
    }
}

private extension CouponView {
    
    func TypeText() -> some View {
        Text(eventsCount == 1 ? "Одинар" : "Экспресс")
            .font(.footnote.weight(.semibold))
            .padding(.vertical, Layouts.tinyOffset)
            .padding(.horizontal, Layouts.smallOffset)
            .background(Capsule().fill(Color.accentColor))
    }
    
    func StatusImage() -> some View {
        Image(systemName: totalStatus.imageName)
            .font(.title3)
            .foregroundStyle(totalStatus.color)
    }
    
    func SummaryStack() -> some View {
        HStack {
            Text(stake)
            Text("x \(totalOdds)")
                .foregroundStyle(.blue)
            Spacer()
            Text(winnings)
                .foregroundStyle(totalStatus.color)
        }
        .font(.callout)
        .monospaced()
    }
}
