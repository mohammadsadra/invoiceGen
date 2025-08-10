//
//  CompanySettingsView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct CompanySettingsView: View {
    @StateObject private var imageManager = ImageStorageManager.shared
    @StateObject private var companyInfoManager = CompanyInfoManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingLogoActionSheet = false
    @State private var showingLogoPicker = false
    @State private var showingLogoCamera = false
    @State private var showingLogoPhotoPicker = false
    
    @State private var showingSignatureActionSheet = false
    @State private var showingSignaturePicker = false
    @State private var showingSignatureCamera = false
    @State private var showingSignaturePhotoPicker = false
    @State private var showingSignatureDrawing = false
    @State private var showingSimpleSignature = false
    
    @State private var selectedImage: UIImage?
    @State private var imageType: ImageType = .logo
    
    // Snackbar state
    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    
    enum ImageType {
        case logo, signature
    }
    
    var body: some View {
        List {
            // Company Information Section
            Section {
                CompanyTextFieldRow(
                    icon: "building.2",
                    iconColor: .blue,
                    title: "نام شرکت",
                    text: $companyInfoManager.companyInfo.name,
                    placeholder: "نام شرکت خود را وارد کنید"
                )
                
                CompanyTextFieldRow(
                    icon: "location",
                    iconColor: .green,
                    title: "آدرس",
                    text: $companyInfoManager.companyInfo.address,
                    placeholder: "آدرس شرکت را وارد کنید"
                )
                
                CompanyTextFieldRow(
                    icon: "building",
                    iconColor: .orange,
                    title: "شهر",
                    text: $companyInfoManager.companyInfo.city,
                    placeholder: "شهر را وارد کنید"
                )
                
                CompanyTextFieldRow(
                    icon: "phone",
                    iconColor: .purple,
                    title: "تلفن",
                    text: $companyInfoManager.companyInfo.phone,
                    placeholder: "شماره تلفن را وارد کنید"
                )
                
                CompanyTextFieldRow(
                    icon: "envelope",
                    iconColor: .red,
                    title: "ایمیل",
                    text: $companyInfoManager.companyInfo.email,
                    placeholder: "آدرس ایمیل را وارد کنید"
                )
                
                CompanyTextFieldRow(
                    icon: "globe",
                    iconColor: .indigo,
                    title: "وب‌سایت",
                    text: $companyInfoManager.companyInfo.website,
                    placeholder: "آدرس وب‌سایت را وارد کنید"
                )
            } header: {
                Text("اطلاعات شرکت")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            // Logo Section
            Section {
                CompanyActionRow(
                    icon: "photo",
                    iconColor: .blue,
                    title: "لوگوی شرکت",
                    subtitle: imageManager.companyLogo != nil ? "لوگو تنظیم شده" : "لوگو تنظیم نشده"
                ) {
                    showingLogoActionSheet = true
                }
                
                if imageManager.companyLogo != nil {
                    CompanyActionRow(
                        icon: "trash",
                        iconColor: .red,
                        title: "حذف لوگو",
                        subtitle: "لوگوی فعلی را حذف کنید"
                    ) {
                        imageManager.deleteCompanyLogo()
                        showSnackbar(message: "لوگو حذف شد")
                    }
                }
            } header: {
                Text("لوگو")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            // Signature Section
            Section {
                CompanyActionRow(
                    icon: "pencil.and.outline",
                    iconColor: .green,
                    title: "امضای شرکت",
                    subtitle: imageManager.signature != nil ? "امضا تنظیم شده" : "امضا تنظیم نشده"
                ) {
                    showingSignatureActionSheet = true
                }
                
                if imageManager.signature != nil {
                    CompanyActionRow(
                        icon: "trash",
                        iconColor: .red,
                        title: "حذف امضا",
                        subtitle: "امضای فعلی را حذف کنید"
                    ) {
                        imageManager.deleteSignature()
                        showSnackbar(message: "امضا حذف شد")
                    }
                }
            } header: {
                Text("امضا")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .navigationTitle("تنظیمات شرکت")
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("ذخیره") {
                    companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
                    showSnackbar(message: "تنظیمات ذخیره شد")
                    dismiss()
                }
                .font(.system(size: 16, weight: .medium))
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "fa_IR"))
        .confirmationDialog("انتخاب لوگو", isPresented: $showingLogoActionSheet) {
            Button("گالری تصاویر") {
                imageType = .logo
                showingLogoPhotoPicker = true
            }
            Button("دوربین") {
                imageType = .logo
                showingLogoCamera = true
            }
            Button("انصراف", role: .cancel) { }
        }
        .confirmationDialog("انتخاب امضا", isPresented: $showingSignatureActionSheet) {
            Button("گالری تصاویر") {
                imageType = .signature
                showingSignaturePhotoPicker = true
            }
            Button("دوربین") {
                imageType = .signature
                showingSignatureCamera = true
            }
            Button("انصراف", role: .cancel) { }
        }
        .sheet(isPresented: $showingLogoPhotoPicker) {
            PhotoPicker(selectedImage: $selectedImage)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .sheet(isPresented: $showingLogoCamera) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .sheet(isPresented: $showingSignaturePhotoPicker) {
            PhotoPicker(selectedImage: $selectedImage)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .sheet(isPresented: $showingSignatureCamera) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .sheet(isPresented: $showingSignatureDrawing) {
            SimpleSignatureView { signature in
                let resizedSignature = imageManager.resizeImage(signature, maxWidth: 300, maxHeight: 100)
                imageManager.saveSignature(resizedSignature)
                showSnackbar(message: "امضا ذخیره شد")
            }
            .environment(\.layoutDirection, .rightToLeft)
            .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .sheet(isPresented: $showingSimpleSignature) {
            SimpleSignatureView { signature in
                let resizedSignature = imageManager.resizeImage(signature, maxWidth: 300, maxHeight: 100)
                imageManager.saveSignature(resizedSignature)
                showSnackbar(message: "امضا ذخیره شد")
            }
            .environment(\.layoutDirection, .rightToLeft)
            .environment(\.locale, Locale(identifier: "fa_IR"))
        }
        .onChange(of: selectedImage) { image in
            handleSelectedImage(image)
        }
        .onChange(of: companyInfoManager.companyInfo.name) { _ in
            companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
        }
        .onChange(of: companyInfoManager.companyInfo.address) { _ in
            companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
        }
        .onChange(of: companyInfoManager.companyInfo.city) { _ in
            companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
        }
        .onChange(of: companyInfoManager.companyInfo.phone) { _ in
            companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
        }
        .onChange(of: companyInfoManager.companyInfo.email) { _ in
            companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
        }
        .onChange(of: companyInfoManager.companyInfo.website) { _ in
            companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
        }
        .overlay(snackbarOverlay)
    }
    
    // MARK: - Helper Functions
    
    private func handleSelectedImage(_ image: UIImage?) {
        guard let image = image else { return }
        
        switch imageType {
        case .logo:
            let resizedLogo = imageManager.resizeImage(image, maxWidth: 300, maxHeight: 150)
            imageManager.saveCompanyLogo(resizedLogo)
            showSnackbar(message: "لوگو شرکت ذخیره شد")
        case .signature:
            let resizedSignature = imageManager.resizeImage(image, maxWidth: 300, maxHeight: 100)
            imageManager.saveSignature(resizedSignature)
            showSnackbar(message: "امضا ذخیره شد")
        }
        
        selectedImage = nil
    }
    
    private func showSnackbar(message: String) {
        snackbarMessage = message
        withAnimation {
            showSnackbar = true
        }
        
        // Auto-hide after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSnackbar = false
            }
        }
    }
    
    private var snackbarOverlay: some View {
        VStack {
            Spacer()
            if showSnackbar {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                    Text(snackbarMessage)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.green)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 50)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showSnackbar)
    }
}

#Preview {
    CompanySettingsView()
}
