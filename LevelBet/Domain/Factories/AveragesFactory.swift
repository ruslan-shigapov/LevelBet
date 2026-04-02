//
//  AveragesFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 02.04.2026.
//

struct Averages {
    
    struct Value {
        
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
                switch coupon.totalStatus {
                case .won:
                    wonAccumulator.add(value)
                    overallAccumulator.add(value)
                case .lost:
                    lostAccumulator.add(value)
                    overallAccumulator.add(value)
                default: break
                }
            }
            return .init(
                overall: overallAccumulator.average,
                won: wonAccumulator.average,
                lost: lostAccumulator.average)
        }
        
        static func averageEventOdds(for coupons: [Coupon]) -> Self {
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

struct AveragesFactory {
    
    static func make(for coupons: [Coupon]) -> Averages {
        .init(
            stake: .average(for: coupons) { Double($0.stake) },
            totalOdds: .average(for: coupons) { $0.totalOdds },
            odds: .averageEventOdds(for: coupons),
            eventCount: .average(for: coupons) { Double($0.events.count) })
    }
}
