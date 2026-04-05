//
//  ModalMetricView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 05.04.2026.
//

import SwiftUI

struct ModalMetricView<Content: View>: View {
    
    let title: String
    let content: Content
    
    var body: some View {
        NavigationStack {
            content
                .background(Color.midnight)
                .scrollContentBackground(.hidden)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
