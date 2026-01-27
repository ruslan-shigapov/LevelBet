//
//  CouponEditorView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI
import SwiftData

struct CouponEditorView: View {
    
    // MARK: - Private Properties
    @Environment(CouponService.self) private var couponService
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate: Date
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            CancelButton()
        }
        ToolbarItem {
            DoneButton()
        }
    }
    
    // MARK: - Public Properties
    var coupon: Coupon?
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                DatePicker(
                    "Дата",
                    selection: $selectedDate,
                    displayedComponents: .date)
                MainSection()
                EventSection()
                if let coupon {
                    DeleteButton(for: coupon)
                }
            }
            .padding(.top, -20)
            .navigationTitle(coupon != nil ? "Детали" : "Новый купон")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
    }
    
    // MARK: - Initialize
    init(coupon: Coupon? = nil) {
        self.coupon = coupon
        _selectedDate = State(initialValue: coupon?.timestamp ?? Date())
    }
}

// MARK: - Views
private extension CouponEditorView {
    
    func CancelButton() -> some View {
        ToolbarButton(type: .cancel) {
            // TODO: add cancel logic
            dismiss()
        }
    }
    
    func DoneButton() -> some View {
        ToolbarButton(type: .done) {
            couponService.addCoupon(stake: 1000)
            dismiss()
        }
    }
    
    func MainSection() -> some View {
        Section {
            Text("Сумма")
            Text("Общий коэффициент")
            Text("Возможный выигрыш")
        }
    }
    
    func EventSection() -> some View {
        Section {
            Button {
                // TODO: add adding logic
            } label: {
                Text("Добавить событие")
            }
            List {
                
            }
        }
    }
    
    func DeleteButton(for coupon: Coupon) -> some View {
        Button {
            couponService.delete(coupon)
            dismiss()
        } label: {
            Text("Удалить купон")
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Coupon.self, Event.self)
    CouponEditorView()
        .modelContainer(container)
        .environment(CouponService(context: container.mainContext))
}
