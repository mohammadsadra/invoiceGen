//
//  SettingsView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                // Settings Section
                Section {
                    NavigationLink(destination: GeneralSettingsView()) {
                        SettingsRowView(
                            icon: "gear",
                            iconColor: .blue,
                            title: "تنظیمات عمومی",
                            subtitle: "تنظیمات کلی برنامه"
                        )
                    }
                    
                    NavigationLink(destination: CompanySettingsView()) {
                        SettingsRowView(
                            icon: "building.2",
                            iconColor: .green,
                            title: "تنظیمات شرکت",
                            subtitle: "اطلاعات و لوگوی شرکت"
                        )
                    }
                } header: {
                    Text("تنظیمات")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                // Support Section
                Section {
                    SettingsRowView(
                        icon: "questionmark.circle",
                        iconColor: .orange,
                        title: "راهنما",
                        subtitle: "آموزش استفاده از برنامه"
                    ) {
                        // TODO: Add help functionality
                    }
                    
                    SettingsRowView(
                        icon: "star",
                        iconColor: .yellow,
                        title: "امتیازدهی",
                        subtitle: "به برنامه امتیاز دهید"
                    ) {
                        // TODO: Add rating functionality
                    }
                } header: {
                    Text("پشتیبانی")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
            .navigationTitle("تنظیمات")
            .navigationBarTitleDisplayMode(.large)
            .environment(\.layoutDirection, .rightToLeft)
            .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "fa_IR"))
    }
}

#Preview {
    SettingsView()
}
