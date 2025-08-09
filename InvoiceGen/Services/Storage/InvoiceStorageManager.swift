//
//  InvoiceStorageManager.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import Foundation

class InvoiceStorageManager: ObservableObject {
    static let shared = InvoiceStorageManager()
    
    @Published var savedInvoices: [Invoice] = []
    
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var invoicesURL: URL {
        return documentsPath.appendingPathComponent("SavedInvoices.json")
    }
    
    private init() {
        loadInvoices()
    }
    
    // MARK: - Save Invoice
    func saveInvoice(_ invoice: Invoice) {
        var updatedInvoice = invoice
        updatedInvoice.updatedAt = Date()
        
        if let index = savedInvoices.firstIndex(where: { $0.id == invoice.id }) {
            // Update existing invoice
            savedInvoices[index] = updatedInvoice
        } else {
            // Add new invoice
            savedInvoices.append(updatedInvoice)
        }
        
        saveToFile()
    }
    
    // MARK: - Delete Invoice
    func deleteInvoice(_ invoice: Invoice) {
        savedInvoices.removeAll { $0.id == invoice.id }
        saveToFile()
    }
    
    func deleteInvoice(at indexSet: IndexSet) {
        savedInvoices.remove(atOffsets: indexSet)
        saveToFile()
    }
    
    // MARK: - Get Invoice
    func getInvoice(by id: UUID) -> Invoice? {
        return savedInvoices.first { $0.id == id }
    }
    
    // MARK: - Duplicate Invoice
    func duplicateInvoice(_ invoice: Invoice) -> Invoice {
        var newInvoice = invoice
        newInvoice = Invoice() // This will generate new ID and invoice number
        newInvoice.customer = invoice.customer
        newInvoice.items = invoice.items
        newInvoice.notes = invoice.notes
        newInvoice.taxRate = invoice.taxRate
        newInvoice.date = Date()
        newInvoice.dueDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        
        return newInvoice
    }
    
    // MARK: - Search Invoices
    func searchInvoices(query: String) -> [Invoice] {
        if query.isEmpty {
            return savedInvoices
        }
        
        return savedInvoices.filter { invoice in
            invoice.invoiceNumber.localizedCaseInsensitiveContains(query) ||
            invoice.customer.name.localizedCaseInsensitiveContains(query) ||
            invoice.notes.localizedCaseInsensitiveContains(query) ||
            invoice.items.contains { $0.description.localizedCaseInsensitiveContains(query) }
        }
    }
    
    // MARK: - Sort Invoices
    func sortedInvoices(by sortOption: InvoiceSortOption) -> [Invoice] {
        switch sortOption {
        case .dateNewest:
            return savedInvoices.sorted { $0.date > $1.date }
        case .dateOldest:
            return savedInvoices.sorted { $0.date < $1.date }
        case .invoiceNumber:
            return savedInvoices.sorted { $0.invoiceNumber < $1.invoiceNumber }
        case .customerName:
            return savedInvoices.sorted { $0.customer.name < $1.customer.name }
        case .totalAmount:
            return savedInvoices.sorted { $0.total > $1.total }
        }
    }
    
    // MARK: - Private Methods
    private func saveToFile() {
        do {
            let data = try JSONEncoder().encode(savedInvoices)
            try data.write(to: invoicesURL)
            print("Invoices saved successfully to: \(invoicesURL.path)")
        } catch {
            print("Failed to save invoices: \(error)")
        }
    }
    
    private func loadInvoices() {
        do {
            let data = try Data(contentsOf: invoicesURL)
            savedInvoices = try JSONDecoder().decode([Invoice].self, from: data)
            print("Loaded \(savedInvoices.count) invoices")
        } catch {
            print("Failed to load invoices (this is normal on first launch): \(error)")
            savedInvoices = []
        }
    }
    
    // MARK: - Statistics
    func getTotalInvoicesCount() -> Int {
        return savedInvoices.count
    }
    
    func getTotalRevenue() -> Double {
        return savedInvoices.reduce(0) { $0 + $1.total }
    }
    
    func getInvoicesThisMonth() -> [Invoice] {
        let calendar = Calendar.current
        let now = Date()
        
        return savedInvoices.filter { invoice in
            calendar.isDate(invoice.date, equalTo: now, toGranularity: .month)
        }
    }
}

// MARK: - Sort Options
enum InvoiceSortOption: String, CaseIterable {
    case dateNewest = "تاریخ (جدیدترین)"
    case dateOldest = "تاریخ (قدیمی‌ترین)"
    case invoiceNumber = "شماره فاکتور"
    case customerName = "نام مشتری"
    case totalAmount = "مبلغ کل"
}
