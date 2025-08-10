//
//  GeneralSettingsView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct GeneralSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingAbout = false
    @State private var showingPrivacy = false
    @State private var showingTerms = false
    
    var body: some View {
        List {
            // Information Section
            Section {
                SettingsRowView(
                    icon: "info.circle",
                    iconColor: .blue,
                    title: "درباره برنامه",
                    subtitle: "اطلاعات نسخه و توسعه‌دهنده"
                ) {
                    showingAbout = true
                }
                
                SettingsRowView(
                    icon: "hand.raised",
                    iconColor: .blue,
                    title: "حریم خصوصی",
                    subtitle: "سیاست حفظ حریم خصوصی"
                ) {
                    showingPrivacy = true
                }
                
                SettingsRowView(
                    icon: "doc.text",
                    iconColor: .blue,
                    title: "شرایط استفاده",
                    subtitle: "قوانین و شرایط استفاده"
                ) {
                    showingTerms = true
                }
            } header: {
                Text("اطلاعات")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            // App Version Section
            Section {
                SettingsInfoRowView(
                    icon: "app.badge",
                    iconColor: .green,
                    title: "نسخه برنامه",
                    value: "1.0.0"
                )
                
                SettingsInfoRowView(
                    icon: "person.circle",
                    iconColor: .purple,
                    title: "توسعه دهنده",
                    value: "mohammadsadra"
                )
                
                SettingsInfoRowView(
                    icon: "calendar",
                    iconColor: .orange,
                    title: "سال انتشار",
                    value: "2025"
                )
            } header: {
                Text("برنامه")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .navigationTitle("تنظیمات عمومی")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                        Text("بازگشت")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "fa_IR"))
        .sheet(isPresented: $showingAbout) {
            AboutView()
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyView()
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .sheet(isPresented: $showingTerms) {
            TermsView()
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "fa_IR"))
        }
    }
}

// MARK: - Detail Views

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // App Icon and Name
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("InvoiceGen")
                                .font(.system(size: 24, weight: .bold))
                            Text("نسخه 1.0.0")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("درباره برنامه")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("InvoiceGen یک برنامه کاربردی برای ایجاد و مدیریت فاکتورها است. این برنامه به شما امکان می‌دهد تا به راحتی فاکتورهای حرفه‌ای ایجاد کنید، مشتریان خود را مدیریت کنید و گزارش‌های مالی تهیه کنید.")
                            .font(.system(size: 16))
                            .lineSpacing(4)
                    }
                    
                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ویژگی‌های کلیدی")
                            .font(.system(size: 20, weight: .semibold))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(icon: "doc.text", text: "ایجاد فاکتورهای حرفه‌ای")
                            FeatureRow(icon: "person.3", text: "مدیریت مشتریان")
                            FeatureRow(icon: "building.2", text: "تنظیمات شرکت")
                            FeatureRow(icon: "square.and.arrow.up", text: "اشتراک و ذخیره PDF")
                            FeatureRow(icon: "chart.bar", text: "گزارش‌های مالی")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("درباره برنامه")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("بستن") {
                        dismiss()
                    }
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "fa_IR"))
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.system(size: 16))
            
            Spacer()
        }
    }
}

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("حریم خصوصی")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("ما متعهد به حفظ حریم خصوصی شما هستیم. این سیاست توضیح می‌دهد که چگونه اطلاعات شما را جمع‌آوری، استفاده و محافظت می‌کنیم.")
                        .font(.system(size: 16))
                        .lineSpacing(4)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("جمع‌آوری اطلاعات")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("• اطلاعات شرکت و مشتریان شما در دستگاه شما ذخیره می‌شود\n• هیچ اطلاعاتی به سرورهای خارجی ارسال نمی‌شود\n• تمام داده‌ها محلی و امن هستند")
                            .font(.system(size: 16))
                            .lineSpacing(4)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("استفاده از اطلاعات")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("• اطلاعات شما فقط برای عملکرد برنامه استفاده می‌شود\n• هیچ اطلاعاتی با اشخاص ثالث به اشتراک گذاشته نمی‌شود\n• شما کنترل کامل بر روی داده‌های خود دارید")
                            .font(.system(size: 16))
                            .lineSpacing(4)
                    }
                }
                .padding()
            }
            .navigationTitle("حریم خصوصی")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("بستن") {
                        dismiss()
                    }
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "fa_IR"))
    }
}

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("شرایط استفاده")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("با استفاده از این برنامه، شما موافقت می‌کنید که از این شرایط استفاده پیروی کنید.")
                        .font(.system(size: 16))
                        .lineSpacing(4)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("استفاده مجاز")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("• استفاده شخصی و تجاری از برنامه مجاز است\n• شما مسئول محتوای فاکتورهای ایجاد شده هستید\n• استفاده غیرقانونی از برنامه ممنوع است")
                            .font(.system(size: 16))
                            .lineSpacing(4)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("محدودیت مسئولیت")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("• برنامه به صورت \"همانطور که هست\" ارائه می‌شود\n• ما مسئولیت خسارات ناشی از استفاده از برنامه را نمی‌پذیریم\n• توصیه می‌شود قبل از استفاده از فاکتورها، آنها را بررسی کنید")
                            .font(.system(size: 16))
                            .lineSpacing(4)
                    }
                }
                .padding()
            }
            .navigationTitle("شرایط استفاده")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("بستن") {
                        dismiss()
                    }
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "fa_IR"))
    }
}

#Preview {
    GeneralSettingsView()
}
