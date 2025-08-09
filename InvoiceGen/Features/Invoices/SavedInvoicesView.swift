//
//  SavedInvoicesView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct SavedInvoicesView: View {
    @StateObject private var storageManager = InvoiceStorageManager.shared
    @State private var searchText = ""
    @State private var sortOption: InvoiceSortOption = .dateNewest
    @State private var showingNewInvoice = false
    @State private var selectedInvoice: Invoice?
    @State private var showingInvoiceDetail = false
    
    var filteredInvoices: [Invoice] {
        let searched = storageManager.searchInvoices(query: searchText)
        return searched.sorted { invoice1, invoice2 in
            switch sortOption {
            case .dateNewest:
                return invoice1.date > invoice2.date
            case .dateOldest:
                return invoice1.date < invoice2.date
            case .invoiceNumber:
                return invoice1.invoiceNumber < invoice2.invoiceNumber
            case .customerName:
                return invoice1.customer.name < invoice2.customer.name
            case .totalAmount:
                return invoice1.total > invoice2.total
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if storageManager.savedInvoices.isEmpty {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("هیچ فاکتوری ذخیره نشده")
                            .font(.vazirmatenTitle)
                            .foregroundColor(.gray)
                        
                        Text("اولین فاکتور خود را بسازید")
                            .font(.vazirmatenBody)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            showingNewInvoice = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("ساخت فاکتور جدید")
                                    .font(.vazirmatenBody)
                            }
                            .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Invoice List
                    List {
                        // Statistics Section
                        Section {
                            HStack {
                                VStack(alignment: .trailing) {
                                    Text("\(storageManager.getTotalInvoicesCount())")
                                        .font(.vazirmatenTitle)
                                        .fontWeight(.bold)
                                    Text("کل فاکتورها")
                                        .font(.vazirmatenCaption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text(PersianNumberFormatter.shared.currencyString(from: storageManager.getTotalRevenue(), currency: .toman))
                                        .font(.vazirmatenHeadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    Text("کل درآمد (تومان)")
                                        .font(.vazirmatenCaption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("\(storageManager.getInvoicesThisMonth().count)")
                                        .font(.vazirmatenHeadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    Text("این ماه")
                                        .font(.vazirmatenCaption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        
                        // Invoices List
                        Section {
                            ForEach(filteredInvoices) { invoice in
                                InvoiceRowView(invoice: invoice) {
                                    selectedInvoice = invoice
                                    showingInvoiceDetail = true
                                }
                            }
                            .onDelete(perform: deleteInvoices)
                        }
                    }
                    .searchable(text: $searchText, prompt: "جستجو در فاکتورها...")
                }
            }
            .navigationTitle("فاکتورهای ذخیره شده")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("مرتب‌سازی", selection: $sortOption) {
                            ForEach(InvoiceSortOption.allCases, id: \.self) { option in
                                Text(option.rawValue)
                                    .font(.vazirmatenBody)
                                    .tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.vazirmatenBody)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewInvoice = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingNewInvoice) {
                InvoiceFormView()
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .sheet(item: $selectedInvoice) { invoice in
                InvoiceDetailView(invoice: invoice)
                    .environment(\.layoutDirection, .rightToLeft)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    func deleteInvoices(offsets: IndexSet) {
        for index in offsets {
            let invoice = filteredInvoices[index]
            storageManager.deleteInvoice(invoice)
        }
    }
}

struct InvoiceRowView: View {
    let invoice: Invoice
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .trailing, spacing: 8) {
                HStack {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(invoice.invoiceNumber)
                            .font(.vazirmatenHeadline)
                            .fontWeight(.semibold)
                        
                        Text(invoice.customer.name.isEmpty ? "بدون نام" : invoice.customer.name)
                            .font(.vazirmatenBody)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(PersianDateFormatter.shared.string(from: invoice.date))
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        
                        Text(PersianNumberFormatter.shared.currencyString(from: invoice.total, currency: invoice.currency))
                            .font(.vazirmatenBody)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
                
                if !invoice.notes.isEmpty {
                    Text(invoice.notes)
                        .font(.vazirmatenCaption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SavedInvoicesView()
}
