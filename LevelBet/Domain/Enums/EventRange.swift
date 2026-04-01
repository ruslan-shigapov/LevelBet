//
//  EventRange.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 30.03.2026.
//

enum EventRange: String, CaseIterable, Identifiable {
    
    case one = "Одинар"
    case two = "2 события"
    case three = "3 события"
    case four = "4 события"
    case fivePlus = "5+ событий"
    
    func matches(count: Int) -> Bool {
        switch self {
        case .one: return count == 1
        case .two: return count == 2
        case .three: return count == 3
        case .four: return count == 4
        case .fivePlus: return count > 4
        }
    }
    
    var id: Self { self }
}
