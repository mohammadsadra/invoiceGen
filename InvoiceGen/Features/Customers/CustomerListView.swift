//
//  CustomerListView.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
//

import SwiftUI

struct CustomerListView: View {
    @StateObject private var customerManager = CustomerManager.shared
    @State private var searchText = ""
    @State private var showingNewCustomer = false
    @State private var showingEditCustomer = false
    @State private var selectedCustomerForEdit: Customer?
    @State private var showingDeleteAlert = false
    @State private var customerToDelete: Customer?
    
    var filteredCustomers: [Customer] {
        if searchText.isEmpty {
            return customerManager.customers.sorted { $0.name < $1.name }
        } else {
            return customerManager.searchCustomers(query: searchText).sorted { $0.name < $1.name }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with Stats
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("تعداد مشتریان")
                                .font(.rtlCaption)
                                .foregroundColor(.rtlSecondary)
                            Text("\(customerManager.getCustomerCount())")
                                .font(.rtlTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.rtlAccent)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("مشتریان اخیر")
                                .font(.rtlCaption)
                                .foregroundColor(.rtlSecondary)
                            Text("\(customerManager.getRecentCustomers(limit: 5).count)")
                                .font(.rtlTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    .rtlPadding()
                    .background(Color(.systemBackground))
                    .rtlCornerRadius(12)
                    .rtlShadow()
                }
                .rtlHorizontalPadding()
                .rtlPadding(.top)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("جستجوی مشتری...", text: $searchText)
                        .font(.rtlBody)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .rtlPadding()
                .background(Color(.systemGray6))
                .rtlCornerRadius(10)
                .rtlHorizontalPadding()
                .rtlPadding(.bottom, 8)
                
                // Customer List
                if filteredCustomers.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "person.3")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text(searchText.isEmpty ? "هیچ مشتری‌ای ثبت نشده است" : "مشتری مورد نظر یافت نشد")
                            .font(.rtlHeadline)
                            .foregroundColor(.gray)
                        
                        Text("برای شروع، مشتری جدید ایجاد کنید")
                            .font(.rtlBody)
                            .foregroundColor(.rtlSecondary)
                        
                        Button(action: {
                            showingNewCustomer = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.title2)
                                Text("مشتری جدید")
                                    .font(.rtlBody)
                            }
                            .rtlPadding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .rtlCornerRadius(10)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredCustomers) { customer in
                            CustomerListRow(
                                customer: customer,
                                onEdit: {
                                    selectedCustomerForEdit = customer
                                    showingEditCustomer = true
                                },
                                onDelete: {
                                    customerToDelete = customer
                                    showingDeleteAlert = true
                                }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("مشتریان")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewCustomer = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
        }
        .rtlEnvironment()
        .sheet(isPresented: $showingNewCustomer) {
            CustomerEditView { newCustomer in
                customerManager.saveCustomer(newCustomer)
            }
        }
        .sheet(isPresented: $showingEditCustomer) {
            if let customerToEdit = selectedCustomerForEdit {
                CustomerEditView(customer: customerToEdit) { updatedCustomer in
                    customerManager.saveCustomer(updatedCustomer)
                    selectedCustomerForEdit = nil
                }
            }
        }
        .alert("حذف مشتری", isPresented: $showingDeleteAlert) {
            Button("حذف", role: .destructive) {
                if let customer = customerToDelete {
                    customerManager.deleteCustomer(customer)
                    customerToDelete = nil
                }
            }
            Button("انصراف", role: .cancel) {
                customerToDelete = nil
            }
        } message: {
            Text("آیا از حذف این مشتری اطمینان دارید؟")
        }
    }
}

struct CustomerListRow: View {
    let customer: Customer
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Customer Avatar
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(customer.name.prefix(1)))
                        .font(.rtlHeadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                )
            
            // Customer Info
            VStack(alignment: .trailing, spacing: 4) {
                Text(customer.name)
                    .font(.rtlHeadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.rtlPrimary)
                
                if !customer.phone.isEmpty {
                    HStack {
                        Image(systemName: "phone")
                            .font(.caption)
                            .foregroundColor(.rtlSecondary)
                        Text(customer.phone)
                            .font(.rtlBody)
                            .foregroundColor(.rtlSecondary)
                    }
                }
                
                if !customer.email.isEmpty {
                    HStack {
                        Image(systemName: "envelope")
                            .font(.caption)
                            .foregroundColor(.rtlSecondary)
                        Text(customer.email)
                            .font(.rtlBody)
                            .foregroundColor(.rtlSecondary)
                    }
                }
                
                if !customer.city.isEmpty {
                    HStack {
                        Image(systemName: "location")
                            .font(.caption)
                            .foregroundColor(.rtlSecondary)
                        Text(customer.city)
                            .font(.rtlBody)
                            .foregroundColor(.rtlSecondary)
                    }
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 8) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .rtlVerticalPadding(8)
    }
}

#Preview {
    CustomerListView()
}
