//
//  InfoView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 14.05.2026.
//

import SwiftUI

struct InfoView: View {
        
    var body: some View {
        NavigationStack {
            ScrollView {
                InfoCard(
                    title: "Профит",
                    text: """
                    Показывает чистую прибыль за выбранный период.
                    """)
                InfoCard(
                    title: "ROI",
                    text: """
                    Показывает окупаемость относительно вложенных средств.
                    
                    Даже небольшое положительное значение на длинной дистанции считается хорошим результатом.
                    """)
                InfoCard(
                    title: "Винрейт по купонам",
                    text: """
                    Показывает процент выигранных купонов от их общего количества.
                    
                    Даже при высоком винрейте профит может быть отрицательным, если коэффициенты слишком низкие.
                    """)
                InfoCard(
                    title: "Винрейт по событиям",
                    text: """
                    Показывает процент выигранных событий внутри всех купонов. Помогает оценить качество выбора событий.
                    
                    Высокий показатель при слабом результате может указывать на слишком большое количество событий в купонах.
                    """)
                InfoCard(
                    title: "Детальный ROI и винрейт",
                    text: """
                    Разбивка показателей по количеству событий, диапазону коэффициентов или виду спорта помогает увидеть слабые и сильные стороны стратегии.
                    """)
                InfoCard(
                    title: "Средние показатели",
                    text: """
                    Показывают общий стиль игры на дистанции. Сравнение значений для выигранных и проигранных купонов помагают оценить закономерности.
                    """)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.midnight)
            .navigationTitle("Справка")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDragIndicator(.visible)
    }
    
    private func InfoCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: Layouts.mediumOffset) {
            Text(title)
                .font(.body.weight(.medium))
            Text(text)
                .font(.body.weight(.light).italic())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
