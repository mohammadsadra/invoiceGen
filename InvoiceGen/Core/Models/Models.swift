//
//  Models.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
//

import Foundation

struct Customer: Identifiable, Codable {
    let id = UUID()
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var address: String = ""
    var city: String = ""
    var postalCode: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    // Initialize with current timestamps
    init() {
        self.name = ""
        self.email = ""
        self.phone = ""
        self.address = ""
        self.city = ""
        self.postalCode = ""
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // Initialize with values
    init(name: String, email: String = "", phone: String = "", address: String = "", city: String = "", postalCode: String = "") {
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.city = city
        self.postalCode = postalCode
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct InvoiceItem: Identifiable, Codable {
    let id = UUID()
    var description: String = ""
    var quantity: Double = 1.0
    var unitPrice: Double = 0.0
    
    var total: Double {
        return quantity * unitPrice
    }
}

enum Currency: String, CaseIterable, Codable {
    case toman = "تومان"
    case rial = "ریال"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Invoice: Identifiable, Codable {
    let id = UUID()
    var invoiceNumber: String = ""
    var date: Date = Date()
    var dueDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    var customer: Customer = Customer()
    var items: [InvoiceItem] = [InvoiceItem()]
    var notes: String = ""
    var taxRate: Double = 0.0
    var discountRate: Double = 0.0 // Discount percentage (0-100)
    var currency: Currency = .toman // Default to Toman
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    var subtotal: Double {
        return items.reduce(0) { $0 + $1.total }
    }
    
    var discountAmount: Double {
        return subtotal * (discountRate / 100)
    }
    
    var subtotalAfterDiscount: Double {
        return subtotal - discountAmount
    }
    
    var taxAmount: Double {
        return subtotalAfterDiscount * (taxRate / 100)
    }
    
    var total: Double {
        return subtotalAfterDiscount + taxAmount
    }
    
    // Initialize with auto-generated invoice number
    init() {
        self.invoiceNumber = "INV-\(String(format: "%04d", Int.random(in: 1000...9999)))"
        self.date = Date()
        self.dueDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        self.customer = Customer()
        self.items = [InvoiceItem()]
        self.notes = ""
        self.taxRate = 0.0
        self.discountRate = 0.0
        self.currency = .toman // Default to Toman
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// Company information (you can customize this)
struct CompanyInfo {
    static let name = "شرکت شما"
    static let address = "آدرس شرکت"
    static let city = "شهر، کشور"
    static let phone = "تلفن: ۰۹۱۲۳۴۵۶۷۸۹"
    static let email = "info@company.com"
    static let website = "www.company.com"
}
