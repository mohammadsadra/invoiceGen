//
//  CustomerSelectionView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct CustomerSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var customerManager = CustomerManager.shared
    
    @State private var searchText = ""
    @State private var showingNewCustomer = false
    @State private var showingEditCustomer = false
    @State private var selectedCustomerForEdit: Customer?
    
    let onCustomerSelected: (Customer) -> Void
    
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
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("جستجوی مشتری...", text: $searchText)
                        .font(.vazirmatenBody)
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
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()
                
                // Customer List
                if filteredCustomers.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "person.3")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text(searchText.isEmpty ? "هیچ مشتری‌ای ثبت نشده است" : "مشتری مورد نظر یافت نشد")
                            .font(.vazirmatenHeadline)
                            .foregroundColor(.gray)
                        
                        Text("برای شروع، مشتری جدید ایجاد کنید")
                            .font(.vazirmatenBody)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            showingNewCustomer = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("مشتری جدید")
                            }
                            .font(.vazirmatenBody)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredCustomers) { customer in
                            CustomerRow(
                                customer: customer,
                                onSelect: {
                                    onCustomerSelected(customer)
                                    dismiss()
                                },
                                onEdit: {
                                    selectedCustomerForEdit = customer
                                    showingEditCustomer = true
                                },
                                onDelete: {
                                    customerManager.deleteCustomer(customer)
                                }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("انتخاب مشتری")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("انصراف") {
                        dismiss()
                    }
                    .font(.vazirmatenBody)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewCustomer = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .font(.vazirmatenBody)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .sheet(isPresented: $showingNewCustomer) {
            CustomerEditView { newCustomer in
                onCustomerSelected(newCustomer)
                dismiss()
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
        .sheet(isPresented: $showingEditCustomer) {
            if let customerToEdit = selectedCustomerForEdit {
                CustomerEditView(customer: customerToEdit) { updatedCustomer in
                    // Customer is automatically updated in the manager
                    selectedCustomerForEdit = nil
                }
                .environment(\.layoutDirection, .rightToLeft)
            }
        }
    }
}

struct CustomerRow: View {
    let customer: Customer
    let onSelect: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(customer.name)
                    .font(.vazirmatenHeadline)
                    .foregroundColor(.primary)
                
                if !customer.phone.isEmpty {
                    Text(customer.phone)
                        .font(.vazirmatenBody)
                        .foregroundColor(.secondary)
                }
                
                if !customer.email.isEmpty {
                    Text(customer.email)
                        .font(.vazirmatenCaption)
                        .foregroundColor(.secondary)
                }
                
                if !customer.city.isEmpty {
                    Text(customer.city)
                        .font(.vazirmatenCaption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
        .alert("حذف مشتری", isPresented: $showingDeleteAlert) {
            Button("حذف", role: .destructive) {
                onDelete()
            }
            Button("انصراف", role: .cancel) { }
        } message: {
            Text("آیا از حذف این مشتری اطمینان دارید؟")
        }
    }
}

#Preview {
    CustomerSelectionView { _ in }
}
