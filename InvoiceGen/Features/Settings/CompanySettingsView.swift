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
        NavigationView {
            Form {
                companyInfoSection
                logoSection
                signatureSection
                helpSection
            }
            .navigationTitle("تنظیمات شرکت")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("ذخیره") {
                        companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
                        showSnackbar(message: "تنظیمات ذخیره شد")
                        dismiss()
                    }
                    .font(.vazirmatenBody)
                }
            }
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
            }
            .sheet(isPresented: $showingLogoCamera) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .sheet(isPresented: $showingSignaturePhotoPicker) {
                PhotoPicker(selectedImage: $selectedImage)
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .sheet(isPresented: $showingSignatureCamera) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                    .environment(\.layoutDirection, .rightToLeft)
            }
            .sheet(isPresented: $showingSignatureDrawing) {
                SimpleSignatureView { signature in
                    let resizedSignature = imageManager.resizeImage(signature, maxWidth: 300, maxHeight: 100)
                    imageManager.saveSignature(resizedSignature)
                    showSnackbar(message: "امضا ذخیره شد")
                }
                .environment(\.layoutDirection, .rightToLeft)
            }
            .onChange(of: selectedImage) { image in
                handleSelectedImage(image)
            }
            .onChange(of: companyInfoManager.companyInfo.name) { _ in
                companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
                showSnackbar(message: "اطلاعات شرکت ذخیره شد")
            }
            .onChange(of: companyInfoManager.companyInfo.address) { _ in
                companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
                showSnackbar(message: "اطلاعات شرکت ذخیره شد")
            }
            .onChange(of: companyInfoManager.companyInfo.city) { _ in
                companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
                showSnackbar(message: "اطلاعات شرکت ذخیره شد")
            }
            .onChange(of: companyInfoManager.companyInfo.phone) { _ in
                companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
                showSnackbar(message: "اطلاعات شرکت ذخیره شد")
            }
            .onChange(of: companyInfoManager.companyInfo.email) { _ in
                companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
                showSnackbar(message: "اطلاعات شرکت ذخیره شد")
            }
            .onChange(of: companyInfoManager.companyInfo.website) { _ in
                companyInfoManager.saveCompanyInfo(companyInfoManager.companyInfo)
                showSnackbar(message: "اطلاعات شرکت ذخیره شد")
            }
        }
        .overlay(snackbarOverlay)
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    // MARK: - Subviews
    
    private var companyInfoSection: some View {
        Section("اطلاعات شرکت") {
            VStack(spacing: 16) {
                TextField("نام شرکت", text: $companyInfoManager.companyInfo.name)
                    .font(.vazirmatenBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("آدرس", text: $companyInfoManager.companyInfo.address)
                    .font(.vazirmatenBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("شهر", text: $companyInfoManager.companyInfo.city)
                    .font(.vazirmatenBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("تلفن", text: $companyInfoManager.companyInfo.phone)
                    .font(.vazirmatenBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
                
                TextField("ایمیل", text: $companyInfoManager.companyInfo.email)
                    .font(.vazirmatenBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                
                TextField("وب‌سایت", text: $companyInfoManager.companyInfo.website)
                    .font(.vazirmatenBody)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.URL)
                
                Button("بازنشانی به پیش‌فرض") {
                    companyInfoManager.resetToDefaults()
                }
                .font(.vazirmatenCaption)
                .foregroundColor(.red)
            }
        }
    }
    
    private var logoSection: some View {
        Section("لوگوی شرکت") {
            VStack(spacing: 16) {
                logoDisplayView
                logoActionButtons
            }
        }
    }
    
    private var logoDisplayView: some View {
        Group {
            if let logo = imageManager.companyLogo {
                Image(uiImage: logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            } else {
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("لوگوی شرکت آپلود نشده")
                        .font(.vazirmatenCaption)
                        .foregroundColor(.secondary)
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
    
    private var logoActionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                imageType = .logo
                showingLogoActionSheet = true
            }) {
                HStack {
                    Image(systemName: "photo.fill")
                        .font(.title2)
                    Text("آپلود لوگو")
                        .font(.vazirmatenBody)
                }
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            
            if imageManager.companyLogo != nil {
                Button(action: {
                    imageManager.deleteCompanyLogo()
                    showSnackbar(message: "لوگو حذف شد")
                }) {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                            .font(.title2)
                        Text("حذف")
                            .font(.vazirmatenBody)
                    }
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
            }
        }
    }
    
    private var signatureSection: some View {
        Section("امضا") {
            VStack(spacing: 16) {
                signatureDisplayView
                signatureActionButtons
            }
        }
    }
    
    private var signatureDisplayView: some View {
        Group {
            if let signature = imageManager.signature {
                Image(uiImage: signature)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 100)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            } else {
                VStack {
                    Image(systemName: "signature")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("امضا آپلود نشده")
                        .font(.vazirmatenCaption)
                        .foregroundColor(.secondary)
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
    
    private var signatureActionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingSignatureDrawing = true
            }) {
                HStack {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                    Text("رسم امضا")
                        .font(.vazirmatenBody)
                }
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.green)
            .cornerRadius(10)
            
            Button(action: {
                showingSimpleSignature = true
            }) {
                HStack {
                    Image(systemName: "signature")
                        .font(.title2)
                    Text("امضای ساده")
                        .font(.vazirmatenBody)
                }
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.orange)
            .cornerRadius(10)
            
            if imageManager.signature != nil {
                Button(action: {
                    imageManager.deleteSignature()
                    showSnackbar(message: "امضا حذف شد")
                }) {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                            .font(.title2)
                        Text("حذف امضا")
                            .font(.vazirmatenBody)
                    }
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.red)
                .cornerRadius(10)
            }
        }
    }
    
    private var helpSection: some View {
        Section("راهنما") {
            VStack(alignment: .leading, spacing: 8) {
                Text("• لوگوی شرکت در بالای فاکتور نمایش داده می‌شود")
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                Text("• امضا در پایین فاکتور قرار می‌گیرد")
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                Text("• تصاویر به صورت خودکار تغییر اندازه می‌یابند")
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
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
                        .font(.vazirmatenBody)
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
}

#Preview {
    CompanySettingsView()
}
