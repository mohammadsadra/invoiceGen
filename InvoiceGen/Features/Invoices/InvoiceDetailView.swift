//
//  InvoiceDetailView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct InvoiceDetailView: View {
    @State var invoice: Invoice
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storageManager = InvoiceStorageManager.shared
    @State private var showingEditForm = false
    @State private var showingPreview = false
    @State private var showingDeleteAlert = false
    @State private var customerToDelete: Invoice?
    
    // Snackbar state
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    invoiceHeaderView
                    customerInformationView
                    itemsView
                    totalsView
                    notesView
                    actionButtonsView
                    metadataView
                }
                .padding()
            }
            .navigationTitle("جزئیات فاکتور")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("بستن") {
                        dismiss()
                    }
                    .font(.vazirmatenBody)
                }
            }
            .sheet(isPresented: $showingEditForm) {
                InvoiceFormView(existingInvoice: invoice) { updatedInvoice in
                    invoice = updatedInvoice
                    storageManager.saveInvoice(updatedInvoice)
                }
            }
            .sheet(isPresented: $showingPreview) {
                InvoicePreviewView(invoice: invoice)
            }
            .alert("حذف فاکتور", isPresented: $showingDeleteAlert) {
                Button("حذف", role: .destructive) {
                    if let customerToDelete = customerToDelete {
                        storageManager.deleteInvoice(customerToDelete)
                    }
                    dismiss()
                }
                Button("انصراف", role: .cancel) { }
            } message: {
                Text("آیا مطمئن هستید که می‌خواهید این فاکتور را حذف کنید؟")
                    .font(.vazirmatenBody)
            }
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
                .animation(.easeInOut(duration: 0.3), value: showSnackbar)
            )
        }
    }
    
    // MARK: - Subviews
    
    private var invoiceHeaderView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(invoice.invoiceNumber)
                .font(.vazirmatenTitle)
                .fontWeight(.bold)
            
            HStack {
                Text("تاریخ سررسید: \(PersianDateFormatter.shared.string(from: invoice.dueDate))")
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("تاریخ صدور: \(PersianDateFormatter.shared.string(from: invoice.date))")
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var customerInformationView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("اطلاعات مشتری")
                .font(.vazirmatenHeadline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 4) {
                if !invoice.customer.name.isEmpty {
                    Text(invoice.customer.name)
                        .font(.vazirmatenBody)
                        .fontWeight(.medium)
                }
                
                if !invoice.customer.email.isEmpty {
                    Text(invoice.customer.email)
                        .font(.vazirmatenBody)
                        .foregroundColor(.blue)
                }
                
                if !invoice.customer.phone.isEmpty {
                    Text(invoice.customer.phone)
                        .font(.vazirmatenBody)
                }
                
                if !invoice.customer.address.isEmpty {
                    Text(invoice.customer.address)
                        .font(.vazirmatenBody)
                }
                
                if !invoice.customer.city.isEmpty {
                    Text(invoice.customer.city)
                        .font(.vazirmatenBody)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var itemsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("اقلام فاکتور")
                .font(.vazirmatenHeadline)
                .fontWeight(.semibold)
            
            ForEach(invoice.items) { item in
                itemRowView(for: item)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func itemRowView(for item: InvoiceItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.description)
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(PersianNumberFormatter.shared.currencyString(from: item.total, currency: invoice.currency))
                    .font(.vazirmatenBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            HStack {
                Text("تعداد:")
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
                
                Text(PersianNumberFormatter.shared.toPersian(item.quantity))
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
                
                Text("×")
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(PersianNumberFormatter.shared.currencyString(from: item.unitPrice, currency: invoice.currency))
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
    
    private var totalsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(PersianNumberFormatter.shared.currencyString(from: invoice.subtotal, currency: invoice.currency))
                    .font(.vazirmatenBody)
                
                Spacer()
                
                Text("جمع کل:")
                    .font(.vazirmatenBody)
            }
            
            if invoice.discountRate > 0 {
                discountSection
            }
            
            if invoice.taxRate > 0 {
                taxSection
            }
            
            HStack {
                Text(PersianNumberFormatter.shared.currencyString(from: invoice.total, currency: invoice.currency))
                    .font(.vazirmatenHeadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("مبلغ قابل پرداخت:")
                    .font(.vazirmatenHeadline)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var discountSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("-\(PersianNumberFormatter.shared.currencyString(from: invoice.discountAmount, currency: invoice.currency))")
                    .font(.vazirmatenBody)
                    .foregroundColor(.red)
                
                Spacer()
                
                Text("تخفیف (\(PersianNumberFormatter.shared.toPersian(invoice.discountRate))%):")
                    .font(.vazirmatenBody)
            }
            
            HStack {
                Text(PersianNumberFormatter.shared.currencyString(from: invoice.subtotalAfterDiscount, currency: invoice.currency))
                    .font(.vazirmatenBody)
                
                Spacer()
                
                Text("جمع پس از تخفیف:")
                    .font(.vazirmatenBody)
            }
        }
    }
    
    private var taxSection: some View {
        HStack {
            Text(PersianNumberFormatter.shared.currencyString(from: invoice.taxAmount, currency: invoice.currency))
                .font(.vazirmatenBody)
            
            Spacer()
            
            Text("مالیات (\(PersianNumberFormatter.shared.toPersian(invoice.taxRate))%):")
                .font(.vazirmatenBody)
        }
    }
    
    private var notesView: some View {
        Group {
            if !invoice.notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("یادداشت")
                        .font(.vazirmatenHeadline)
                        .fontWeight(.semibold)
                    
                    Text(invoice.notes)
                        .font(.vazirmatenBody)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            Button("پیش‌نمایش و تولید PDF") {
                showingPreview = true
            }
            .font(.vazirmatenBody)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            HStack(spacing: 12) {
                editButton
                copyButton
                deleteButton
            }
        }
        .padding(.top)
    }
    
    private var editButton: some View {
        Button(action: {
            showingEditForm = true
        }) {
            HStack {
                Image(systemName: "pencil.circle.fill")
                    .font(.title2)
                Text("ویرایش")
                    .font(.vazirmatenBody)
            }
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green)
        .cornerRadius(10)
    }
    
    private var copyButton: some View {
        Button(action: {
            let duplicated = storageManager.duplicateInvoice(invoice)
            storageManager.saveInvoice(duplicated)
            showSnackbar(message: "فاکتور کپی شد")
        }) {
            HStack {
                Image(systemName: "doc.on.doc.fill")
                    .font(.title2)
                Text("کپی")
                    .font(.vazirmatenBody)
            }
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
    }
    
    private var deleteButton: some View {
        Button(action: {
            customerToDelete = invoice
            showingDeleteAlert = true
        }) {
            HStack {
                Image(systemName: "trash.circle.fill")
                    .font(.title2)
                Text("حذف")
                    .font(.vazirmatenBody)
            }
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red)
        .cornerRadius(10)
    }
    
    private var metadataView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("ایجاد شده: \(PersianDateFormatter.shared.string(from: invoice.createdAt))")
                .font(.vazirmatenCaption)
                .foregroundColor(.secondary)
            
            Text("آخرین تغییر: \(PersianDateFormatter.shared.string(from: invoice.updatedAt))")
                .font(.vazirmatenCaption)
                .foregroundColor(.secondary)
        }
        .padding(.top)
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
    let sampleInvoice = Invoice()
    InvoiceDetailView(invoice: sampleInvoice)
}
