//
//  ROIDetailsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 25.03.2026.
//

import SwiftUI

struct ROIDetailsView: View {
    
    let coupons: [Coupon]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Количество событий") {
                    LabeledROI(title: "Одинар", value: "22 %")
                    LabeledROI(title: "2 события", value: "22 %")
                    LabeledROI(title: "3 события", value: "22 %")
                    LabeledROI(title: "4 события", value: "22 %")
                    LabeledROI(title: "5+ события", value: "22 %")
                }
                Section("Диапазон коэффициентов") {
                    LabeledROI(title: "1,01 - 1,40", value: "22 %")
                    LabeledROI(title: "1,41 - 1,60", value: "22 %")
                    LabeledROI(title: "1,61 - 1,80", value: "22 %")
                    LabeledROI(title: "1,81 - 2,00", value: "22 %")
                    LabeledROI(title: "2,01 - 2,20", value: "22 %")
                    LabeledROI(title: "2,21 - 2,40", value: "22 %")
                    LabeledROI(title: "2,40+", value: "22 %")
                }
                Section("Вид спорта") {
                    LabeledROI(title: "Футбол", value: "22 %")
                    LabeledROI(title: "Хоккей", value: "22 %")
                }
            }
            .background(Color.midnight)
            .scrollContentBackground(.hidden)
            .navigationTitle("Срезы ROI")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func LabeledROI(title: String, value: String) -> some View {
        LabeledContent(title, value: value)
            .listRowBackground(Color(uiColor: .systemGroupedBackground))
    }
}
