//
//  Statuses+Extension.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI

extension Statuses {
    
    var color: Color {
        switch self {
        case .all: .accentColor
        case .pending: .orange
        case .won: .green
        case .lost: .pink
        }
    }
}
