//
//  Double+Extension.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.03.2026.
//

import Foundation

extension Double {
    
    var oddsFormatted: String {
        formatted(.number.precision(.fractionLength(2)))
    }
    
    var fractionFormatted: String {
        formatted(.percent.precision(.fractionLength(0...1)))
    }
}
