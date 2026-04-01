//
//  OddsRange.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 31.03.2026.
//

enum OddsRange: String, CaseIterable, Identifiable {
    
    case from101to200 = "1,01 - 2,00"
    case from201to400 = "2,01 - 4,00"
    case from401to800 = "4,01 - 8,00"
    case from801to1600 = "8,01 - 16,00"
    case from1601to3200 = "16,01 - 32,00"
    case from3200Plus = "32,00+"
    
    func matches(odds: Double) -> Bool {
        switch self {
        case .from101to200: odds >= 1.01 && odds <= 2.00
        case .from201to400: odds >= 2.01 && odds <= 4.00
        case .from401to800: odds >= 4.01 && odds <= 8.00
        case .from801to1600: odds >= 8.01 && odds <= 16.00
        case .from1601to3200: odds >= 16.01 && odds <= 32.00
        case .from3200Plus: odds > 32.00
        }
    }
    
    var id: Self { self }
}
