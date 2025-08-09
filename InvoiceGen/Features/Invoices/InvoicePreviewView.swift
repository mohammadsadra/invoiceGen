//
//  InvoicePreviewView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct InvoicePreviewView: View {
    let invoice: Invoice
    @Environment(\.dismiss) private var dismiss
    @State private var isExporting = false
    @State private var pdfData: Data?
    @State private var showingDocumentPicker = false
    @State private var showingShareSheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @StateObject private var imageManager = ImageStorageManager.shared
    @StateObject private var companyInfoManager = CompanyInfoManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with Logo
                    VStack(alignment: .center, spacing: 12) {
                        if let logo = imageManager.companyLogo {
                            Image(uiImage: logo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 80)
                        }
                        
                        Text(companyInfoManager.companyInfo.name)
                            .font(.vazirmatenTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(companyInfoManager.companyInfo.address)
                            .font(.vazirmatenBody)
                        Text(companyInfoManager.companyInfo.city)
                            .font(.vazirmatenBody)
                        Text(companyInfoManager.companyInfo.phone)
                            .font(.vazirmatenBody)
                        Text(companyInfoManager.companyInfo.email)
                            .font(.vazirmatenBody)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                    
                    Divider()
                    
                    // Invoice Info
                    HStack {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("فاکتور")
                                .font(.vazirmatenTitle)
                                .fontWeight(.bold)
                            Text("شماره: \(invoice.invoiceNumber)")
                                .font(.vazirmatenHeadline)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("تاریخ صدور: \(PersianDateFormatter.shared.string(from: invoice.date))")
                                .font(.vazirmatenBody)
                            Text("تاریخ سررسید: \(PersianDateFormatter.shared.string(from: invoice.dueDate))")
                                .font(.vazirmatenBody)
                        }
                    }
                    
                    Divider()
                    
                    // Customer Info
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("صورتحساب برای:")
                            .font(.vazirmatenHeadline)
                            .fontWeight(.semibold)
                        
                        Text(invoice.customer.name)
                            .font(.vazirmatenBody)
                            .fontWeight(.medium)
                        
                        if !invoice.customer.email.isEmpty {
                            Text(invoice.customer.email)
                                .font(.vazirmatenBody)
                                .foregroundColor(.blue)
                        }
                        
                        if !invoice.customer.phone.isEmpty {
                            Text(invoice.customer.phone)
                                .font(.vazirmatenBody)
                        }
                        
                        if !invoice.customer.address.isEmpty {
                            Text(invoice.customer.address)
                                .font(.vazirmatenBody)
                        }
                        
                        if !invoice.customer.city.isEmpty {
                            Text(invoice.customer.city)
                                .font(.vazirmatenBody)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    // Items Table
                    VStack(spacing: 0) {
                        // Table Header
                        HStack {
                            Text("شرح")
                                .font(.vazirmatenBody)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text("تعداد")
                                .font(.vazirmatenBody)
                                .fontWeight(.semibold)
                                .frame(width: 60, alignment: .center)
                            Text("قیمت واحد")
                                .font(.vazirmatenBody)
                                .fontWeight(.semibold)
                                .frame(width: 80, alignment: .trailing)
                            Text("جمع")
                                .font(.vazirmatenBody)
                                .fontWeight(.semibold)
                                .frame(width: 80, alignment: .trailing)
                        }
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.1))
                        
                        // Table Rows
                        ForEach(invoice.items) { item in
                            HStack {
                                Text(item.description)
                                    .font(.vazirmatenBody)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                Text(PersianNumberFormatter.shared.toPersian(item.quantity))
                                    .font(.vazirmatenBody)
                                    .frame(width: 60, alignment: .center)
                                Text(PersianNumberFormatter.shared.currencyString(from: item.unitPrice, currency: invoice.currency))
                                    .font(.vazirmatenBody)
                                    .frame(width: 80, alignment: .trailing)
                                Text(PersianNumberFormatter.shared.currencyString(from: item.total, currency: invoice.currency))
                                    .font(.vazirmatenBody)
                                    .frame(width: 80, alignment: .trailing)
                            }
                            .padding(.vertical, 8)
                            .background(Color.clear)
                            
                            Divider()
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    
                    // Totals
                    VStack(spacing: 8) {
                        HStack {
                            Text(PersianNumberFormatter.shared.currencyString(from: invoice.subtotal, currency: invoice.currency))
                                .font(.vazirmatenBody)
                                .frame(width: 120, alignment: .leading)
                            Spacer()
                            Text("جمع کل:")
                                .font(.vazirmatenBody)
                        }
                        
                        if invoice.discountRate > 0 {
                            HStack {
                                Text("-\(PersianNumberFormatter.shared.currencyString(from: invoice.discountAmount, currency: invoice.currency))")
                                    .font(.vazirmatenBody)
                                    .foregroundColor(.red)
                                    .frame(width: 120, alignment: .leading)
                                Spacer()
                                Text("تخفیف (\(PersianNumberFormatter.shared.toPersian(invoice.discountRate))%):")
                                    .font(.vazirmatenBody)
                            }
                            
                            HStack {
                                Text(PersianNumberFormatter.shared.currencyString(from: invoice.subtotalAfterDiscount, currency: invoice.currency))
                                    .font(.vazirmatenBody)
                                    .frame(width: 120, alignment: .leading)
                                Spacer()
                                Text("جمع پس از تخفیف:")
                                    .font(.vazirmatenBody)
                            }
                        }
                        
                        if invoice.taxRate > 0 {
                            HStack {
                                Text(PersianNumberFormatter.shared.currencyString(from: invoice.taxAmount, currency: invoice.currency))
                                    .font(.vazirmatenBody)
                                    .frame(width: 120, alignment: .leading)
                                Spacer()
                                Text("مالیات (\(PersianNumberFormatter.shared.toPersian(invoice.taxRate))%):")
                                    .font(.vazirmatenBody)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            Text(PersianNumberFormatter.shared.currencyString(from: invoice.total, currency: invoice.currency))
                                .font(.vazirmatenHeadline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .frame(width: 120, alignment: .leading)
                            Spacer()
                            Text("مبلغ نهایی:")
                                .font(.vazirmatenHeadline)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.top, 16)
                    
                    // Notes
                    if !invoice.notes.isEmpty {
                        Divider()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("یادداشت:")
                                .font(.vazirmatenHeadline)
                                .fontWeight(.semibold)
                            Text(invoice.notes)
                                .font(.vazirmatenBody)
                        }
                    }
                    
                    // Signature
                    if let signature = imageManager.signature {
                        Divider()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("امضا:")
                                .font(.vazirmatenHeadline)
                                .fontWeight(.semibold)
                            
                            Image(uiImage: signature)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 60)
                                .frame(maxWidth: 200)
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationTitle("پیش‌نمایش فاکتور")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                            Text("بازگشت")
                                .font(.vazirmatenBody)
                        }
                        .foregroundColor(.red)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            generateAndSharePDF()
                        }) {
                            Label("اشتراک‌گذاری PDF", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(action: {
                            generateAndSavePDF()
                        }) {
                            Label("ذخیره در فایل‌ها", systemImage: "folder.badge.plus")
                        }
                    } label: {
                        if isExporting {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "doc.badge.plus")
                        }
                    }
                    .disabled(isExporting)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .sheet(isPresented: $showingShareSheet) {
            if let data = pdfData {
                ShareSheet(activityItems: [createPDFURL(from: data)])
            }
        }
        .fileExporter(
            isPresented: $showingDocumentPicker,
            document: pdfData.map { PDFDocument(data: $0) },
            contentType: .pdf,
            defaultFilename: "Invoice_\(invoice.invoiceNumber)"
        ) { result in
            switch result {
            case .success(let url):
                alertMessage = "فایل PDF با موفقیت ذخیره شد"
                showingAlert = true
                print("PDF saved to: \(url)")
            case .failure(let error):
                alertMessage = "خطا در ذخیره فایل: \(error.localizedDescription)"
                showingAlert = true
                print("Error saving PDF: \(error)")
            }
        }
        .alert("پیام", isPresented: $showingAlert) {
            Button("باشه") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func generateAndSharePDF() {
        isExporting = true
        
        Task {
            let data = await PDFGenerator.generateInvoicePDF(invoice: invoice)
            
            DispatchQueue.main.async {
                self.isExporting = false
                self.pdfData = data
                self.showingShareSheet = true
            }
        }
    }
    
    private func generateAndSavePDF() {
        isExporting = true
        
        Task {
            let data = await PDFGenerator.generateInvoicePDF(invoice: invoice)
            
            DispatchQueue.main.async {
                self.isExporting = false
                self.pdfData = data
                self.showingDocumentPicker = true
            }
        }
    }
    
    private func sharePDF(data: Data) {
        let fileName = "Invoice_\(invoice.invoiceNumber).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: tempURL)
            
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
                
                // Configure for iPad
                if let popover = activityVC.popoverPresentationController {
                    popover.sourceView = UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .flatMap { $0.windows }
                        .first { $0.isKeyWindow }?.rootViewController?.view
                    popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                    popover.permittedArrowDirections = []
                }
                
                // Find the topmost view controller
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                   let rootVC = window.rootViewController {
                    
                    var topVC = rootVC
                    while let presentedVC = topVC.presentedViewController {
                        topVC = presentedVC
                    }
                    
                    topVC.present(activityVC, animated: true)
                }
            }
        } catch {
            print("Error sharing PDF: \(error)")
            // Show an alert to the user
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                   let rootVC = window.rootViewController {
                    
                    let alert = UIAlertController(title: "خطا", message: "خطا در ذخیره فایل PDF", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "باشه", style: .default))
                    
                    var topVC = rootVC
                    while let presentedVC = topVC.presentedViewController {
                        topVC = presentedVC
                    }
                    
                    topVC.present(alert, animated: true)
                }
            }
        }
    }
    
    private func createPDFURL(from data: Data) -> URL {
        let fileName = "Invoice_\(invoice.invoiceNumber).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("Error creating PDF file: \(error)")
            return tempURL
        }
    }
}

// MARK: - Supporting Types

struct PDFDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.pdf] }
    
    var data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents ?? Data()
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    var sampleInvoice = Invoice()
    sampleInvoice.invoiceNumber = "INV-001"
    sampleInvoice.customer.name = "علی احمدی"
    sampleInvoice.customer.email = "ali@example.com"
    sampleInvoice.customer.phone = "09123456789"
    sampleInvoice.customer.address = "خیابان ولیعصر"
    sampleInvoice.customer.city = "تهران"
    
    var item1 = InvoiceItem()
    item1.description = "طراحی وب‌سایت"
    item1.quantity = 1
    item1.unitPrice = 5000000
    
    var item2 = InvoiceItem()
    item2.description = "پشتیبانی ماهانه"
    item2.quantity = 3
    item2.unitPrice = 500000
    
    sampleInvoice.items = [item1, item2]
    sampleInvoice.notes = "لطفاً تا تاریخ سررسید پرداخت نمایید."
    sampleInvoice.taxRate = 9
    
    return InvoicePreviewView(invoice: sampleInvoice)
}
