//
//  ExtraMetricFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 09.03.2026.
//

import Foundation

enum ExtraMetricFactory {
    
    // MARK: Private Methods
    private static func roi(for coupons: [Coupon]) -> Double {
        var totalStake = 0
        var totalWinnings = 0
        for coupon in coupons {
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
        }
        return totalStake > 0
        ? Double(totalWinnings - totalStake) / Double(totalStake)
        : 0
    }
    
    private static func winRate(for coupons: [Coupon]) -> Double {
        guard !coupons.isEmpty else { return 0 }
        var wins = 0
        for coupon in coupons {
            if coupon.totalStatus == .won {
                wins += 1
            }
        }
        return Double(wins) / Double(coupons.count)
    }
    
    // MARK: Public Methods
    static func profit(for coupons: [Coupon]) -> Int {
        var totalWinnings = 0
        var totalStake = 0
        for coupon in coupons {
            guard coupon.totalStatus != .pending else { continue }
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
        }
        guard totalStake > 0 else { return 0 }
        return totalWinnings - totalStake
    }
    
    static func roi(
        for coupons: [Coupon],
        byEventRange eventRange: EventRange
    ) -> Double {
        let filtered = coupons.filter {
            eventRange.matches(count: $0.events.count)
        }
        return roi(for: filtered)
    }
    
    static func roi(
        for coupons: [Coupon],
        byOddsRange oddsRange: OddsRange
    ) -> Double {
        let filtered = coupons.filter {
            oddsRange.matches(odds: $0.totalOdds)
        }
        return roi(for: filtered)
    }
    
    static func winRate(
        for coupons: [Coupon],
        byEventRange eventRange: EventRange
    ) -> Double {
        let filtered = coupons.filter {
            eventRange.matches(count: $0.events.count)
        }
        return winRate(for: filtered)
    }
    
    static func winRate(
        for coupons: [Coupon],
        byOddsRange oddsRange: OddsRange
    ) -> Double {
        let filtered = coupons.filter {
            oddsRange.matches(odds: $0.totalOdds)
        }
        return winRate(for: filtered)
    }
    
    static func eventWinRate(
        for coupons: [Coupon],
        byEventOddsRange oddsRange: EventOddsRange
    ) -> Double {
        var total = 0
        var won = 0
        for coupon in coupons {
            for event in coupon.events {
                if oddsRange.matches(odds: event.odds) {
                    total += 1
                    if event.status == .won {
                        won += 1
                    }
                }
            }
        }
        return total > 0 ? Double(won) / Double(total) : 0
    }
    
    static func eventWinRate(
        for coupons: [Coupon],
        bySport sport: Sports
    ) -> Double {
        var total = 0
        var won = 0
        for coupon in coupons {
            for event in coupon.events {
                if event.sport == sport {
                    total += 1
                    if event.status == .won {
                        won += 1
                    }
                }
            }
        }
        return total > 0 ? Double(won) / Double(total) : 0
    }
}
