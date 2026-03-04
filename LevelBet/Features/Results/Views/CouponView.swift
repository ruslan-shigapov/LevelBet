//
//  CouponView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI

struct CouponView: View {
    
    private var formattedOdds: String {
        coupon.totalOdds.formatted(.number.precision(.fractionLength(0...2)))
    }
    
    let coupon: Coupon
    
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
        Text(coupon.events.count == 1 ? "Одинар" : "Экспресс")
            .font(.footnote.weight(.semibold))
            .padding(.vertical, Layouts.tinyOffset)
            .padding(.horizontal, Layouts.smallOffset)
            .background(Capsule().fill(Color.accentColor))
    }
    
    func StatusImage() -> some View {
        Image(systemName: coupon.totalStatus.imageName)
            .font(.title3)
            .foregroundStyle(coupon.totalStatus.color)
    }
    
    func SummaryStack() -> some View {
        HStack {
            Text(coupon.stake.formatted())
            Text("x \(formattedOdds)")
                .foregroundStyle(.blue)
            Spacer()
            Text(coupon.winnings.formatted())
                .foregroundStyle(coupon.totalStatus.color)
        }
        .font(.callout)
        .monospaced()
    }
}
