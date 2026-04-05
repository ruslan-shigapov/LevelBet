//
//  LabeledWinRateView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 05.04.2026.
//

import SwiftUI

struct LabeledWinRateView: View {
    
    let title: String
    let value: Double
    
    var body: some View {
        LabeledContent(title, value: value.fractionFormatted)
            .listRowBackground(Color(uiColor: .systemGroupedBackground))
    }
}
