//
//  View+Extension.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.02.2026.
//

import SwiftUI

extension View {
    
    func errorAlert(
        message: Binding<String?>,
        isPresented: Binding<Bool>
    ) -> some View {
        self.alert("Ошибка", isPresented: isPresented) {
            Button("OK", role: .cancel) {
                message.wrappedValue = nil
            }
        } message: {
            Text((message.wrappedValue ?? "") + " Попробуйте еще раз.")
        }
    }
}
