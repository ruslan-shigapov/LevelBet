//
//  Statuses.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

enum Statuses: String, Codable, CaseIterable, Identifiable {
    
    case all = "Все купоны"
    case pending = "Ожидаются"
    case won = "Выиграные"
    case lost = "Проиграные"
    
    var imageName: String {
        switch self {
        case .all: "circle"
        case .pending: "clock"
        case .won: "checkmark.circle"
        case .lost: "xmark.circle"
        }
    }
    
    var id: Self { self }
}
