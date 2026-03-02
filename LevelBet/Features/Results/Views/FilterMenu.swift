//
//  FilterMenu.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 24.02.2026.
//

import SwiftUI

struct FilterMenu: View {
    
    @Binding var selectedPeriod: Periods
    
    var body: some View {
        Menu {
            Text("Период:")
            Divider()
            ForEach(Periods.allCases) { period in
                Button {
                    selectedPeriod = period
                } label: {
                    Label {
                        Text(period.rawValue)
                    } icon: {
                        if selectedPeriod == period {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
        }
    }
}
