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
                // Modern Header with Progress
                modernHeaderView
                
                // Modern Section Picker
                modernSectionPicker
                
                // Form Content
                ScrollView {
                    LazyVStack(spacing: 24) {
                        switch activeSection {
                        case .basic:
                            modernBasicInfoSection
                        case .customer:
                            modernCustomerSection
                        case .items:
                            modernItemsSection
                        case .financial:
                            modernFinancialSection
                        case .notes:
                            modernNotesSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                
                // Modern Bottom Action Bar
                modernBottomActionBar
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
                .environment(\.layoutDirection, .rightToLeft)
        }
        .sheet(isPresented: $showingCustomerSelection) {
            CustomerSelectionView { selectedCustomer in
                invoice.customer = selectedCustomer
            }
            .environment(\.layoutDirection, .rightToLeft)
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
            // Modern Snackbar
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
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showSnackbar)
        )
    }
    
    // MARK: - Modern Header View
    private var modernHeaderView: some View {
        VStack(spacing: 20) {
            // Progress Indicator
            HStack(spacing: 8) {
                ForEach(FormSection.allCases, id: \.self) { section in
                    Circle()
                        .fill(activeSection == section ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(activeSection == section ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: activeSection)
                }
            }
            .padding(.top)
            
            // Modern Invoice Summary Card
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("شماره فاکتور")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        Text(invoice.invoiceNumber)
                            .font(.vazirmatenHeadline)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
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
            .padding(20)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    // MARK: - Modern Section Picker
    private var modernSectionPicker: some View {
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
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(activeSection == section ? Color.blue : Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(activeSection == section ? Color.clear : Color(.systemGray4), lineWidth: 1)
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Modern Basic Info Section
    private var modernBasicInfoSection: some View {
        VStack(spacing: 24) {
            // Invoice Number
            ModernFormField(
                title: "شماره فاکتور",
                placeholder: "INV-001",
                text: $invoice.invoiceNumber
            )
            
            // Date Selection
            ModernDateField(
                title: "تاریخ صدور",
                date: $invoice.date
            )
            
            // Due Date Selection
            ModernDateField(
                title: "تاریخ سررسید",
                date: $invoice.dueDate
            )
        }
    }
    
    // MARK: - Modern Customer Section
    private var modernCustomerSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingCustomerSelection = true
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        if invoice.customer.name.isEmpty {
                            HStack {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.blue)
                                Text("انتخاب مشتری")
                                    .font(.vazirmatenBody)
                                    .foregroundColor(.blue)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 4) {
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
                .padding(20)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Modern Items Section
    private var modernItemsSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("اقلام فاکتور")
                    .font(.vazirmatenHeadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
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
                modernItemCard(for: index)
            }
        }
    }
    
    private func modernItemCard(for index: Int) -> some View {
        VStack(spacing: 16) {
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
            
            VStack(spacing: 16) {
                ModernFormField(
                    title: "شرح کالا یا خدمات",
                    placeholder: "شرح کالا یا خدمات",
                    text: $invoice.items[index].description
                )
                
                HStack(spacing: 12) {
                    ModernNumberField(
                        title: "تعداد",
                        placeholder: "1",
                        value: $invoice.items[index].quantity
                    )
                    
                    ModernNumberField(
                        title: "قیمت واحد",
                        placeholder: "0",
                        value: $invoice.items[index].unitPrice
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("جمع")
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                        Text(PersianNumberFormatter.shared.currencyString(from: invoice.items[index].total, currency: invoice.currency))
                            .font(.vazirmatenBody)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .cornerRadius(12)
    }
    
    // MARK: - Modern Financial Section
    private var modernFinancialSection: some View {
        VStack(spacing: 24) {
            // Currency Selection
            VStack(alignment: .leading, spacing: 8) {
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
            ModernNumberField(
                title: "نرخ مالیات (%)",
                placeholder: "0",
                value: $invoice.taxRate
            )
            
            // Discount Rate
            ModernNumberField(
                title: "نرخ تخفیف (%)",
                placeholder: "0",
                value: $invoice.discountRate
            )
            
            // Account/Card Number
            ModernFormField(
                title: "شماره حساب یا شماره کارت",
                placeholder: "شماره حساب یا کارت بانکی را وارد کنید",
                text: $invoice.accountNumber
            )
            
            // Summary Card
            VStack(spacing: 16) {
                HStack {
                    Text("جمع کل:")
                    Spacer()
                    Text(PersianNumberFormatter.shared.currencyString(from: invoice.subtotal, currency: invoice.currency))
                }
                .font(.vazirmatenBody)
                
                if invoice.discountRate > 0 {
                    HStack {
                        Text("تخفیف:")
                        Spacer()
                        Text("-\(PersianNumberFormatter.shared.currencyString(from: invoice.discountAmount, currency: invoice.currency))")
                            .foregroundColor(.red)
                    }
                    .font(.vazirmatenBody)
                }
                
                if invoice.taxRate > 0 {
                    HStack {
                        Text("مالیات:")
                        Spacer()
                        Text(PersianNumberFormatter.shared.currencyString(from: invoice.taxAmount, currency: invoice.currency))
                            .foregroundColor(.orange)
                    }
                    .font(.vazirmatenBody)
                }
                
                Divider()
                
                HStack {
                    Spacer()
                    Text(PersianNumberFormatter.shared.currencyString(from: invoice.total, currency: invoice.currency))
                        .font(.vazirmatenHeadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(20)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }
    
    // MARK: - Modern Notes Section
    private var modernNotesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("یادداشت")
                .font(.vazirmatenBody)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            TextField("یادداشت اضافی...", text: $invoice.notes, axis: .vertical)
                .font(.vazirmatenBody)
                .lineLimit(3...6)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
    
    // MARK: - Modern Bottom Action Bar
    private var modernBottomActionBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: {
                    saveInvoice()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("ذخیره")
                    }
                    .font(.vazirmatenBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    showingPreview = true
                }) {
                    HStack {
                        Image(systemName: "eye.fill")
                        Text("پیش‌نمایش")
                    }
                    .font(.vazirmatenBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray4)),
            alignment: .top
        )
    }
    
    // MARK: - Helper Functions
    private func saveInvoice() {
        if let onSave = onSave {
            onSave(invoice)
        } else {
            storageManager.saveInvoice(invoice)
        }
        showSnackbar(message: "فاکتور با موفقیت ذخیره شد")
    }
    
    private func showSnackbar(message: String) {
        snackbarMessage = message
        withAnimation {
            showSnackbar = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSnackbar = false
            }
        }
    }
}

// MARK: - Modern Form Components
struct ModernFormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.vazirmatenBody)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .font(.vazirmatenBody)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
}

struct ModernNumberField: View {
    let title: String
    let placeholder: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.vazirmatenBody)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            TextField(placeholder, value: $value, format: .number)
                .font(.vazirmatenBody)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
}

struct ModernDateField: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.vazirmatenBody)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.vazirmatenCaption)
                        .foregroundColor(.secondary)
                    Text(PersianDateFormatter.shared.string(from: date))
                        .font(.vazirmatenBody)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .environment(\.calendar, Calendar(identifier: .persian))
                    .environment(\.locale, Locale(identifier: "fa_IR"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .cornerRadius(8)
        }
    }
}

#Preview {
    InvoiceFormView()
}
