//
//  CouponEditorView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI

struct CouponEditorView: View {
    
    // MARK: - Private Properties
    @Environment(CouponService.self) private var couponService
    @Environment(\.dismiss) private var dismiss
        
    @State private var selectedDate: Date
    @State private var stake: String
    @State private var events: [Event]
    @State private var isModalViewPresented = false
    @State private var alertMessage: String?
    @State private var isAlertPresented = false
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            ToolbarButton(type: .cancel) {
                dismiss()
            }
        }
        ToolbarItem {
            ToolbarButton(type: .done) {
                saveCoupon()
            }
            .disabled(!isFormValid)
        }
    }
    
    private var totalOdds: Double {
        guard !events.isEmpty else { return 0 }
        return events.reduce(1) { $0 * $1.odds }
    }
    
    private var isFormValid: Bool {
        !stake.isEmpty && stake != "0" && !events.isEmpty
    }
    
    var totalStatus: Statuses {
        if events.contains(where: { $0.status == .lost }) {
            return .lost
        } else if !events.isEmpty && events.allSatisfy({ $0.status == .won }) {
            return .won
        } else {
            return .pending
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
                    in: ...Date(),
                    displayedComponents: .date)
                MainSectionView(
                    stake: $stake,
                    totalOdds: totalOdds,
                    totalStatus: totalStatus)
                EventSectionView(
                    isModalViewPresented: $isModalViewPresented,
                    events: $events)
                if let coupon {
                    DeleteButton(for: coupon)
                }
            }
            .background(Color.midnight)
            .scrollContentBackground(.hidden)
            .navigationTitle(coupon != nil ? "Детали" : "Новый купон")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .sheet(isPresented: $isModalViewPresented) {
                AddEventView {
                    events.append($0)
                }
            }
            .errorAlert(message: $alertMessage, isPresented: $isAlertPresented)
        }
    }
    
    // MARK: - Initialize
    init(coupon: Coupon? = nil) {
        self.coupon = coupon
        _selectedDate = State(initialValue: coupon?.timestamp ?? Date())
        if let stake = coupon?.stake, stake != 0 {
            _stake = State(initialValue: String(stake))
        } else {
            _stake = State(initialValue: "")
        }
        _events = State(initialValue: coupon?.events ?? [])
    }
    
    // MARK: - Private Methods
    private func saveCoupon() {
        do {
            if let coupon {
                try couponService.update(
                    coupon,
                    date: selectedDate,
                    stake: stake,
                    events: events,
                    totalStatus: totalStatus)
            } else {
                try couponService.createCoupon(
                    date: selectedDate,
                    stake: stake,
                    events: events,
                    totalStatus: totalStatus)
            }
            dismiss()
        } catch {
            showAlert(for: error)
        }
    }
    
    private func showAlert(for error: Error) {
        alertMessage = (error as? DataError)?.description
        isAlertPresented = true
    }
}

// MARK: - Views
private extension CouponEditorView {
    
    func DeleteButton(for coupon: Coupon) -> some View {
        Button {
            do {
                try couponService.delete(coupon)
                dismiss()
            } catch {
                showAlert(for: error)
            }
        } label: {
            Text("Удалить купон")
                .foregroundStyle(.red)
        }
    }
}
