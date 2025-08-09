//
//  InvoiceFormView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct InvoiceFormView: View {
    @State private var invoice: Invoice
    @State private var showingPreview = false
    @StateObject private var storageManager = InvoiceStorageManager.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // Snackbar state
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    
    // Customer selection state
    @State private var showingCustomerSelection = false
    
    // Form state
    @State private var activeSection: FormSection = .basic
    @State private var showingDeleteAlert = false
    
    let existingInvoice: Invoice?
    let onSave: ((Invoice) -> Void)?
    
    enum FormSection: String, CaseIterable {
        case basic = "اطلاعات پایه"
        case customer = "مشتری"
        case items = "اقلام"
        case financial = "مالی"
        case notes = "یادداشت"
    }
    
    init(existingInvoice: Invoice? = nil, onSave: ((Invoice) -> Void)? = nil) {
        self.existingInvoice = existingInvoice
        self.onSave = onSave
        self._invoice = State(initialValue: existingInvoice ?? Invoice())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Header with Progress
                headerView
                
                // Section Picker
                sectionPicker
                
                // Form Content
                ScrollView {
                    LazyVStack(spacing: 20) {
                        switch activeSection {
                        case .basic:
                            basicInfoSection
                        case .customer:
                            customerSection
                        case .items:
                            itemsSection
                        case .financial:
                            financialSection
                        case .notes:
                            notesSection
                        }
                    }
                    .padding()
                }
                
                // Bottom Action Bar
                bottomActionBar
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(existingInvoice != nil ? "ویرایش فاکتور" : "فاکتور جدید")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if existingInvoice != nil || onSave != nil {
                        Button("انصراف") {
                            dismiss()
                        }
                        .font(.vazirmatenBody)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if existingInvoice != nil {
                        Button("حذف") {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(.red)
                        .font(.vazirmatenBody)
                    }
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .sheet(isPresented: $showingPreview) {
            InvoicePreviewView(invoice: invoice)
        }
        .sheet(isPresented: $showingCustomerSelection) {
            CustomerSelectionView { selectedCustomer in
                invoice.customer = selectedCustomer
            }
        }
        .alert("حذف فاکتور", isPresented: $showingDeleteAlert) {
            Button("حذف", role: .destructive) {
                if let existingInvoice = existingInvoice {
                    storageManager.deleteInvoice(existingInvoice)
                }
                dismiss()
            }
            Button("انصراف", role: .cancel) { }
        } message: {
            Text("آیا از حذف این فاکتور اطمینان دارید؟")
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
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showSnackbar)
        )
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 16) {
            // Progress Indicator
            HStack(spacing: 8) {
                ForEach(FormSection.allCases, id: \.self) { section in
                    Circle()
                        .fill(activeSection == section ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(activeSection == section ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: activeSection)
                }
            }
            .padding(.top)
            
            // Invoice Summary Card
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("شماره فاکتور")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        Text(invoice.invoiceNumber)
                            .font(.vazirmatenHeadline)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("مبلغ کل")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        Text(PersianNumberFormatter.shared.currencyString(from: invoice.total, currency: invoice.currency))
                            .font(.vazirmatenHeadline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                
                if !invoice.customer.name.isEmpty {
                        HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.green)
                        Text(invoice.customer.name)
                                .font(.vazirmatenBody)
                                .foregroundColor(.primary)
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(FormSection.allCases, id: \.self) { section in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            activeSection = section
                        }
                    }) {
                        Text(section.rawValue)
                            .font(.vazirmatenBody)
                            .fontWeight(activeSection == section ? .semibold : .regular)
                            .foregroundColor(activeSection == section ? .white : .primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(activeSection == section ? Color.blue : Color(.systemGray5))
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Basic Info Section
    private var basicInfoSection: some View {
        VStack(spacing: 16) {
            // Invoice Number
            VStack(alignment: .trailing, spacing: 8) {
                Text("شماره فاکتور")
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                TextField("INV-001", text: $invoice.invoiceNumber)
                    .font(.vazirmatenBody)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            // Date Selection
            VStack(alignment: .trailing, spacing: 12) {
                Text("تاریخ صدور")
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                HStack {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("تاریخ صدور")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        Text(PersianDateFormatter.shared.string(from: invoice.date))
                            .font(.vazirmatenBody)
                    }
                    
                    Spacer()
                    
                        DatePicker("", selection: $invoice.date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .environment(\.calendar, Calendar(identifier: .persian))
                            .environment(\.locale, Locale(identifier: "fa_IR"))
                    }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            
            // Due Date Selection
            VStack(alignment: .trailing, spacing: 12) {
                Text("تاریخ سررسید")
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                        HStack {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("تاریخ سررسید")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                            Text(PersianDateFormatter.shared.string(from: invoice.dueDate))
                                .font(.vazirmatenBody)
                        }
                    
                    Spacer()
                    
                        DatePicker("", selection: $invoice.dueDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .environment(\.calendar, Calendar(identifier: .persian))
                            .environment(\.locale, Locale(identifier: "fa_IR"))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
                    }
                }
                
    // MARK: - Customer Section
    private var customerSection: some View {
        VStack(spacing: 16) {
                    Button(action: {
                        showingCustomerSelection = true
                    }) {
                        HStack {
                    VStack(alignment: .trailing, spacing: 8) {
                                if invoice.customer.name.isEmpty {
                            HStack {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.blue)
                                    Text("انتخاب مشتری")
                                        .font(.vazirmatenBody)
                                        .foregroundColor(.blue)
                            }
                                } else {
                            VStack(alignment: .trailing, spacing: 4) {
                                    Text(invoice.customer.name)
                                        .font(.vazirmatenHeadline)
                                    .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    
                                    if !invoice.customer.phone.isEmpty {
                                    HStack {
                                        Image(systemName: "phone")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(invoice.customer.phone)
                                            .font(.vazirmatenBody)
                                            .foregroundColor(.secondary)
                                    }
                                    }
                                    
                                    if !invoice.customer.email.isEmpty {
                                    HStack {
                                        Image(systemName: "envelope")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(invoice.customer.email)
                                            .font(.vazirmatenBody)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                if !invoice.customer.address.isEmpty {
                                    HStack {
                                        Image(systemName: "location")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text("\(invoice.customer.address)\(invoice.customer.city.isEmpty ? "" : ", \(invoice.customer.city)")")
                                            .font(.vazirmatenBody)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                    Image(systemName: invoice.customer.name.isEmpty ? "plus.circle.fill" : "pencil.circle.fill")
                                .foregroundColor(.blue)
                        .font(.title2)
                        }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
    }
    
    // MARK: - Items Section
    private var itemsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("اقلام فاکتور")
                    .font(.vazirmatenHeadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        invoice.items.append(InvoiceItem())
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            
            ForEach(invoice.items.indices, id: \.self) { index in
                itemCard(for: index)
            }
        }
    }
    
    private func itemCard(for index: Int) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("قلم \(index + 1)")
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                Spacer()
                
                if invoice.items.count > 1 {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            var updatedItems = invoice.items
                            updatedItems.remove(at: index)
                            invoice.items = updatedItems
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            VStack(spacing: 12) {
                TextField("شرح کالا یا خدمات", text: $invoice.items[index].description)
                    .font(.vazirmatenBody)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                HStack(spacing: 12) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("تعداد")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        TextField("1", value: $invoice.items[index].quantity, format: .number)
                            .font(.vazirmatenBody)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("قیمت واحد")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        TextField("0", value: $invoice.items[index].unitPrice, format: .number)
                            .font(.vazirmatenBody)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("جمع")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        Text(PersianNumberFormatter.shared.currencyString(from: invoice.items[index].total, currency: invoice.currency))
                            .font(.vazirmatenBody)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Financial Section
    private var financialSection: some View {
        VStack(spacing: 16) {
            // Currency Selection
            VStack(alignment: .trailing, spacing: 8) {
                Text("واحد پول")
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                        Picker("واحد پول", selection: $invoice.currency) {
                            ForEach(Currency.allCases, id: \.self) { currency in
                                Text(currency.displayName)
                                    .font(.vazirmatenBody)
                                    .tag(currency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            
            // Tax Rate
            VStack(alignment: .trailing, spacing: 8) {
                Text("نرخ مالیات (%)")
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                TextField("0", value: $invoice.taxRate, format: .number)
                    .font(.vazirmatenBody)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            // Discount Rate
            VStack(alignment: .trailing, spacing: 8) {
                Text("نرخ تخفیف (%)")
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                TextField("0", value: $invoice.discountRate, format: .number)
                    .font(.vazirmatenBody)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            // Summary Card
            VStack(spacing: 12) {
                    HStack {
                        Text(PersianNumberFormatter.shared.currencyString(from: invoice.subtotal, currency: invoice.currency))
                        Spacer()
                        Text("جمع کل:")
                    }
                .font(.vazirmatenBody)
                    
                    if invoice.discountRate > 0 {
                        HStack {
                        Text("-\(PersianNumberFormatter.shared.currencyString(from: invoice.discountAmount, currency: invoice.currency))")
                                .foregroundColor(.red)
                            Spacer()
                            Text("تخفیف:")
                        }
                                .font(.vazirmatenBody)
                    }
                    
                    if invoice.taxRate > 0 {
                        HStack {
                        Text(PersianNumberFormatter.shared.currencyString(from: invoice.taxAmount, currency: invoice.currency))
                            .foregroundColor(.orange)
                        Spacer()
                            Text("مالیات:")
                    }
                    .font(.vazirmatenBody)
                }
                
                Divider()
                
                HStack {
                    Text(PersianNumberFormatter.shared.currencyString(from: invoice.total, currency: invoice.currency))
                        .font(.vazirmatenHeadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Spacer()
                    Text("مبلغ قابل پرداخت:")
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text("یادداشت")
                .font(.vazirmatenBody)
                .fontWeight(.medium)
            
            TextField("یادداشت اضافی...", text: $invoice.notes, axis: .vertical)
                .font(.vazirmatenBody)
                .lineLimit(3...6)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
    
    // MARK: - Bottom Action Bar
    private var bottomActionBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: {
                    showingPreview = true
                }) {
                    HStack {
                        Image(systemName: "eye.fill")
                            .font(.title2)
                        Text("پیش‌نمایش")
                            .font(.vazirmatenBody)
                    }
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .disabled(invoice.customer.name.isEmpty || invoice.items.isEmpty)
                
                Button(action: {
                    saveInvoice()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                        Text("ذخیره")
                            .font(.vazirmatenBody)
                    }
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(12)
                .disabled(invoice.customer.name.isEmpty || invoice.items.isEmpty)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: -2)
    }
    
    // MARK: - Helper Functions
    private func saveInvoice() {
        storageManager.saveInvoice(invoice)
        onSave?(invoice)
        showSnackbar(message: "فاکتور ذخیره شد")
        
        // Delay dismiss to show snackbar
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
    
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
    InvoiceFormView()
}
