//
//  CustomerManager.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
//

import Foundation
import SwiftUI

class CustomerManager: ObservableObject {
    static let shared = CustomerManager()
    
    @Published var customers: [Customer] = []
    
    private let customersKey = "SavedCustomers"
    
    init() {
        loadCustomers()
    }
    
    // MARK: - Customer Management
    
    func saveCustomer(_ customer: Customer) {
        var updatedCustomer = customer
        updatedCustomer.updatedAt = Date()
        
        if let index = customers.firstIndex(where: { $0.id == customer.id }) {
            // Update existing customer
            customers[index] = updatedCustomer
        } else {
            // Add new customer
            customers.append(updatedCustomer)
        }
        
        saveCustomers()
    }
    
    func deleteCustomer(_ customer: Customer) {
        customers.removeAll { $0.id == customer.id }
        saveCustomers()
    }
    
    func getCustomer(by id: UUID) -> Customer? {
        return customers.first { $0.id == id }
    }
    
    func searchCustomers(query: String) -> [Customer] {
        if query.isEmpty {
            return customers
        }
        
        return customers.filter { customer in
            customer.name.localizedCaseInsensitiveContains(query) ||
            customer.email.localizedCaseInsensitiveContains(query) ||
            customer.phone.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Persistence
    
    private func saveCustomers() {
        do {
            let data = try JSONEncoder().encode(customers)
            UserDefaults.standard.set(data, forKey: customersKey)
        } catch {
            print("Failed to save customers: \(error)")
        }
    }
    
    private func loadCustomers() {
        guard let data = UserDefaults.standard.data(forKey: customersKey) else {
            // Create some sample customers for first launch
            createSampleCustomers()
            return
        }
        
        do {
            customers = try JSONDecoder().decode([Customer].self, from: data)
        } catch {
            print("Failed to load customers: \(error)")
            customers = []
            createSampleCustomers()
        }
    }
    
    private func createSampleCustomers() {
        let sampleCustomers = [
            Customer(name: "احمد محمدی", email: "ahmad@example.com", phone: "09123456789", address: "خیابان ولیعصر، پلاک ۱۲۳", city: "تهران", postalCode: "1234567890"),
            Customer(name: "فاطمه احمدی", email: "fateme@example.com", phone: "09987654321", address: "خیابان آزادی، پلاک ۴۵۶", city: "اصفهان", postalCode: "0987654321")
        ]
        
        customers = sampleCustomers
        saveCustomers()
    }
    
    // MARK: - Statistics
    
    func getCustomerCount() -> Int {
        return customers.count
    }
    
    func getRecentCustomers(limit: Int = 5) -> [Customer] {
        return customers
            .sorted { $0.updatedAt > $1.updatedAt }
            .prefix(limit)
            .map { $0 }
    }
}
