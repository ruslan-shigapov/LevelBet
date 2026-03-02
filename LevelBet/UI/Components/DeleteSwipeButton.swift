//
//  DeleteSwipeButton.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 02.03.2026.
//

import SwiftUI

struct DeleteSwipeButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(role: .destructive) {
            withAnimation(.snappy) {
                action()
            }
        } label: {
            Image(systemName: "trash")
        }
    }
}
