//
//  CouponView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI

struct CouponView: View {
    
    let coupon: Coupon
    
    var body: some View {
        Text(
            coupon.timestamp,
            format: Date.FormatStyle(date: .numeric, time: .standard))
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
    }
}
