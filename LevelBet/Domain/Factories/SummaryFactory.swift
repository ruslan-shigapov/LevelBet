//
//  SummaryFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 02.04.2026.
//

struct Summary {
    let profit: Int
    let roi: Double
    let totalStake: Int
    let settledCount: Int
    let winRate: Double
    let eventWinRate: Double
}

enum SummaryFactory {
    
    private static func eventWinRate(for coupons: [Coupon]) -> Double {
        var total = 0
        var won = 0
        for coupon in coupons {
            for event in coupon.events {
                total += 1
                if event.status == .won {
                    won += 1
                }
            }
        }
        return total > 0 ? Double(won) / Double(total) : 0
    }
    
    static func make(for coupons: [Coupon]) -> Summary {
        var totalStake = 0
        var totalWinnings = 0
        var won = 0
        for coupon in coupons {
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
            if coupon.totalStatus == .won {
                won += 1
            }
        }
        let profit = totalWinnings - totalStake
        let roi = totalStake > 0 ? Double(profit) / Double(totalStake) : 0
        let winRate = Double(won) / Double(coupons.count)
        return .init(
            profit: profit,
            roi: roi,
            totalStake: totalStake,
            settledCount: coupons.count,
            winRate: winRate,
            eventWinRate: eventWinRate(for: coupons))
    }
}
