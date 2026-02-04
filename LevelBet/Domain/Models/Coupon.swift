//
//  Coupon.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import Foundation
import SwiftData

@Model
final class Coupon {
    
    var timestamp: Date
    var stake: Decimal
    
    @Relationship(deleteRule: .cascade)
    var events: [Event] = []
    
    var totalOdds: Decimal {
        events.reduce(1) { $0 * $1.odds }
    }
    
    var totalStatus: Statuses {
        // TODO: add status calculating somewhere 
        .pending
    }
    
    init(timestamp: Date, stake: Decimal) {
        self.timestamp = timestamp
        self.stake = stake
    }
}
