//
//  CouponService.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftData
import Foundation

enum DataError: Error {
    case createFailure, updateFailure, deleteFailure
    
    var description: String {
        switch self {
        case .createFailure: "Не удалось создать купон."
        case .updateFailure: "Не удалось изменить купон."
        case .deleteFailure: "Не удалось удалить купон."
        }
    }
}

@MainActor
@Observable
final class CouponService {
        
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func createCoupon(
        date: Date,
        stake: String,
        events: [Event],
        totalStatus: Statuses
    ) throws {
        let coupon = Coupon(
            timestamp: date,
            stake: Int(stake.replacingOccurrences(of: " ", with: "")) ?? 0,
            totalStatus: totalStatus)
        coupon.events = events
        events.forEach { $0.coupon = coupon }
        context.insert(coupon)
        do {
            try context.save()
        } catch {
            throw DataError.createFailure
        }
    }
    
    func update(
        _ coupon: Coupon,
        date: Date,
        stake: String,
        events: [Event],
        totalStatus: Statuses
    ) throws {
        coupon.timestamp = date
        coupon.stake = Int(stake.replacingOccurrences(of: " ", with: "")) ?? 0
        coupon.totalStatus = totalStatus
        coupon.events.forEach { $0.coupon = nil }
        coupon.events = events
        events.forEach { $0.coupon = coupon }
        do {
            try context.save()
        } catch {
            throw DataError.updateFailure
        }
    }
    
    func delete(_ coupon: Coupon) throws {
        context.delete(coupon)
        do {
            try context.save()
        } catch {
            throw DataError.deleteFailure
        }
    }
}
