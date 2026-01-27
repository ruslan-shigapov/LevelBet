//
//  Periods.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

enum Periods: String, CaseIterable, Identifiable {
    
    case week = "Неделя"
    case month = "Месяц"
    case year = "Год"
    
    var id: Self { self }
}
