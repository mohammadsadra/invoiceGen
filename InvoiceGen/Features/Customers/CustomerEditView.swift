//
//  CustomerEditView.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
//

import SwiftUI

struct CustomerEditView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var customerManager = CustomerManager.shared
    
    @State private var customer: Customer
    let isNewCustomer: Bool
    let onSave: (Customer) -> Void
    
    // Snackbar state
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    
    init(customer: Customer? = nil, onSave: @escaping (Customer) -> Void) {
        if let existingCustomer = customer {
            self._customer = State(initialValue: existingCustomer)
            self.isNewCustomer = false
        } else {
            self._customer = State(initialValue: Customer())
            self.isNewCustomer = true
        }
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("اطلاعات مشتری") {
                    TextField("نام مشتری", text: $customer.name)
                        .font(.vazirmatenBody)
                    
                    TextField("ایمیل", text: $customer.email)
                        .font(.vazirmatenBody)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("تلفن", text: $customer.phone)
                        .font(.vazirmatenBody)
                        .keyboardType(.phonePad)
                    
                    TextField("آدرس", text: $customer.address)
                        .font(.vazirmatenBody)
                    
                    TextField("شهر", text: $customer.city)
                        .font(.vazirmatenBody)
                    
                    TextField("کد پستی", text: $customer.postalCode)
                        .font(.vazirmatenBody)
                        .keyboardType(.numberPad)
                }
                
                if !isNewCustomer {
                    Section("اطلاعات سیستم") {
                        HStack {
                            Text("تاریخ ایجاد:")
                                .font(.vazirmatenCaption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(PersianDateFormatter.shared.string(from: customer.createdAt))
                                .font(.vazirmatenCaption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("آخرین بروزرسانی:")
                                .font(.vazirmatenCaption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(PersianDateFormatter.shared.string(from: customer.updatedAt))
                                .font(.vazirmatenCaption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle(isNewCustomer ? "مشتری جدید" : "ویرایش مشتری")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                            Text("انصراف")
                                .font(.vazirmatenBody)
                        }
                        .foregroundColor(.red)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveCustomer()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                            Text("ذخیره")
                                .font(.vazirmatenBody)
                        }
                        .foregroundColor(.green)
                    }
                    .disabled(customer.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .overlay(
            // Snackbar
            VStack {
                Spacer()
                if showSnackbar {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text(snackbarMessage)
                            .font(.vazirmatenBody)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        )
    }
    
    private func saveCustomer() {
        // Validate required fields
        guard !customer.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // Save to customer manager
        customerManager.saveCustomer(customer)
        
        // Call the completion handler
        onSave(customer)
        
        // Show success message
        showSnackbar(message: isNewCustomer ? "مشتری جدید ایجاد شد" : "اطلاعات مشتری بروزرسانی شد")
        
        // Delay dismiss to show snackbar
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
    
    // MARK: - Helper Functions
    private func showSnackbar(message: String) {
        snackbarMessage = message
        withAnimation {
            showSnackbar = true
        }
        
        // Auto-hide after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSnackbar = false
            }
        }
    }
}

#Preview {
    CustomerEditView { _ in }
}
