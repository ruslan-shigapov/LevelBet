//
//  MetricFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 09.03.2026.
//

import Foundation

private struct Accumulator {
    var sum = 0.0
    var count = 0
    
    mutating func add(_ value: Double) {
        sum += value
        count += 1
    }
    
    var average: Double {
        count == 0 ? 0 : sum / Double(count)
    }
}

enum MetricFactory {
    
    // MARK: Summary
    struct Summary {
        let settledCount: Int
        let totalStake: Int
        let profit: Int
        let roi: Double
        let winRate: Double
        let eventWinRate: Double
    }
    
    // MARK: Averages
    struct Averages {
        
        struct Value {
            
            let overall: Double
            let won: Double
            let lost: Double
            
            static func average(
                for coupons: [Coupon],
                metric: (Coupon) -> Double
            ) -> Self {
                var overallAccumulator = Accumulator()
                var wonAccumulator = Accumulator()
                var lostAccumulator = Accumulator()
                for coupon in coupons {
                    let value = metric(coupon)
                    overallAccumulator.add(value)
                    switch coupon.totalStatus {
                    case .won: wonAccumulator.add(value)
                    case .lost: lostAccumulator.add(value)
                    default: break
                    }
                }
                
                return .init(
                    overall: overallAccumulator.average,
                    won: wonAccumulator.average,
                    lost: lostAccumulator.average)
            }
            
            static func averageOdds(for coupons: [Coupon]) -> Self {
                var overallAccumulator = Accumulator()
                var wonAccumulator = Accumulator()
                var lostAccumulator = Accumulator()
                for coupon in coupons {
                    for event in coupon.events {
                        overallAccumulator.add(event.odds)
                        switch event.status {
                        case .won: wonAccumulator.add(event.odds)
                        case .lost: lostAccumulator.add(event.odds)
                        default: break
                        }
                    }
                }
                return .init(
                    overall: overallAccumulator.average,
                    won: wonAccumulator.average,
                    lost: lostAccumulator.average)
            }
        }
        
        let stake: Value
        let totalOdds: Value
        let odds: Value
        let eventCount: Value
    }
    
    // MARK: Private Methods
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
    
    static func summary(for coupons: [Coupon]) -> Summary {
        var totalStake = 0
        var totalWinnings = 0
        var wins = 0
        for coupon in coupons {
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
            if coupon.totalStatus == .won {
                wins += 1
            }
        }
        let profit = totalWinnings - totalStake
        let roi = totalStake > 0 ? Double(profit) / Double(totalStake) : 0
        let winRate = coupons.isEmpty ? 0 : Double(wins) / Double(coupons.count)
        return .init(
            settledCount: coupons.count,
            totalStake: totalStake,
            profit: profit,
            roi: roi,
            winRate: winRate,
            eventWinRate: eventWinRate(for: coupons))
    }
    
    static func averages(for coupons: [Coupon]) -> Averages {
        .init(
            stake: .average(for: coupons) { Double($0.stake) },
            totalOdds: .average(for: coupons) { $0.totalOdds },
            odds: .averageOdds(for: coupons),
            eventCount: .average(for: coupons) { Double($0.events.count) })
    }
}
