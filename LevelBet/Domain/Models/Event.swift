//
//  Event.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 26.01.2026.
//

import SwiftData
import Foundation

@Model
final class Event {
    
    var sport: Sports
    var odds: Decimal
    var coupon: Coupon?
    
    init(sport: Sports, odds: Decimal, coupon: Coupon?) {
        self.sport = sport
        self.odds = odds
        self.coupon = coupon
    }
}
