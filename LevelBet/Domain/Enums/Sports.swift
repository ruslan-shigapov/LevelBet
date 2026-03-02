//
//  Sports.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 26.01.2026.
//

enum Sports: String, Codable, CaseIterable, Identifiable {
    
    case football = "Футбол"
    case hockey = "Хоккей"
    case tennis = "Теннис"
    case basketball = "Баскетбол"
    case esports = "Киберспорт"
    
    var imageName: String {
        switch self {
        case .football: "soccerball"
        case .hockey: "hockey.puck"
        case .tennis: "tennisball"
        case .basketball: "basketball"
        case .esports: "gamecontroller"
        }
    }
    
    var id: Self { self }
}
