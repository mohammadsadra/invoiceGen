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
                        .font(.vazirmatenCaption)
                }
            
            SavedInvoicesView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("فاکتورهای ذخیره شده")
                        .font(.vazirmatenCaption)
                }

            CustomerListView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("مشتریان")
                        .font(.vazirmatenCaption)
                }
            
            CompanySettingsView()
                .tabItem {
                    Image(systemName: "building.2")
                    Text("تنظیمات")
                        .font(.vazirmatenCaption)
                }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    MainTabView()
}
