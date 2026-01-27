//
//  Statuses.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

enum Statuses: String, CaseIterable, Identifiable {
    
    case all = "Все купоны"
    case pending = "Ожидаются"
    case won = "Выиграные"
    case lost = "Проиграные"
    
    var id: Self { self }
}
