//
//  FilterFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 04.03.2026.
//

import Foundation

struct FilterFactory {
    
    static func matches(
        coupon: Coupon,
        period: Periods,
        status: Statuses? = nil
    ) -> Bool {
        let calendar = Calendar.current
        let startDate: Date? = {
            switch period {
            case .week:
                calendar.date(byAdding: .day, value: -7, to: .now)
            case .month:
                calendar.date(byAdding: .month, value: -1, to: .now)
            case .year:
                calendar.date(byAdding: .year, value: -1, to: .now)
            }
        }()
        guard let startDate else { return false }
        let matchesStatus: Bool
        if let status {
            matchesStatus = status == .all || coupon.totalStatus == status
        } else {
            matchesStatus = coupon.totalStatus != .pending
        }
        return coupon.timestamp >= startDate && matchesStatus
    }
}
