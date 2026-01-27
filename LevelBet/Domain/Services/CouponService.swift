//
//  CouponService.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftData
import Foundation

@Observable
final class CouponService {
        
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func addCoupon(stake: Decimal) {
        let newCoupon = Coupon(timestamp: Date(), stake: stake)
        context.insert(newCoupon)
        try! context.save()
    }
    
    func delete(_ coupon: Coupon) {
        context.delete(coupon)
        try! context.save()
    }
}
