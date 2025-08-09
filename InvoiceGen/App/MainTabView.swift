//
//  MainTabView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            InvoiceFormView()
                .tabItem {
                    Image(systemName: "doc.badge.plus")
                    Text("فاکتور جدید")
                        .font(.rtlCaption)
                }
            
            SavedInvoicesView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("فاکتورهای ذخیره شده")
                        .font(.rtlCaption)
                }

            CustomerListView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("مشتریان")
                        .font(.rtlCaption)
                }
            
            CompanySettingsView()
                .tabItem {
                    Image(systemName: "building.2")
                    Text("تنظیمات")
                        .font(.rtlCaption)
                }
        }
        .rtlEnvironment()
    }
}

#Preview {
    MainTabView()
}
