//
//  EventOddsRange.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 01.04.2026.
//

enum EventOddsRange: String, CaseIterable, Identifiable {
    
    case from101to140 = "1,01 - 1,40"
    case from141to160 = "1,41 - 1,60"
    case from161to180 = "1,61 - 1,80"
    case from181to200 = "1,81 - 2,00"
    case from201to240 = "2,01 - 2,40"
    case from241to300 = "2,41 - 3,00"
    case from300Plus = "3,00+"
    
    func matches(odds: Double) -> Bool {
        switch self {
        case .from101to140: odds >= 1.01 && odds <= 1.40
        case .from141to160: odds >= 1.41 && odds <= 1.60
        case .from161to180: odds >= 1.61 && odds <= 1.80
        case .from181to200: odds >= 1.81 && odds <= 2.00
        case .from201to240: odds >= 2.01 && odds <= 2.40
        case .from241to300: odds >= 2.41 && odds <= 3.00
        case .from300Plus: odds > 3.00
        }
    }
    
    var id: Self { self }
}
