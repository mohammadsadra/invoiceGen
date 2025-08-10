//
//  InvoicePreviewView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI
import UniformTypeIdentifiers
import PDFKit

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
            VStack(spacing: 0) {
                // PDF Viewer
                if let data = pdfData {
                    PDFKitView(data: data)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Loading or placeholder
                    VStack {
                        ProgressView("در حال تولید PDF...")
                            .font(.vazirmatenBody)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("پیش‌نمایش فاکتور")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                    }
                    .frame(width: 44, height: 44)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        // Save PDF Button
                        Button(action: {
                            generateAndSavePDF()
                        }) {
                            if isExporting {
                                ProgressView()
                                    .scaleEffect(0.6)
                            } else {
                                Image(systemName: "doc.badge.plus")
                                    .font(.system(size: 16))
                            }
                        }
                        .frame(width: 44, height: 44)
                        .disabled(isExporting)
                        
                        // Share Button
                        Button(action: {
                            generateAndSharePDF()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16))
                        }
                        .frame(width: 44, height: 44)
                    }
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            generatePDF()
        }
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
    
    // MARK: - Header Section
    private var modernHeaderSection: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("پیش فاکتور")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.bottom, 10)
    }
    
    // MARK: - Invoice Info Section
    private var modernInvoiceInfoSection: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("تاریخ: \(PersianDateFormatter.shared.string(from: invoice.date))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Text("شماره فاکتور: \(invoice.invoiceNumber)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .padding(.bottom, 15)
    }
    
    // MARK: - Company Information Section
    private var modernCompanySection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("مشخصات فروشنده:")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            HStack(alignment: .top, spacing: 15) {
                // Company Info
                VStack(alignment: .trailing, spacing: 8) {
                    Text("نام شرکت: \(companyInfoManager.companyInfo.name)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    if !companyInfoManager.companyInfo.phone.isEmpty {
                        Text("تلفن: \(companyInfoManager.companyInfo.phone)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    if !companyInfoManager.companyInfo.email.isEmpty {
                        Text("ایمیل: \(companyInfoManager.companyInfo.email)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    if !companyInfoManager.companyInfo.website.isEmpty {
                        Text("وب‌سایت: \(companyInfoManager.companyInfo.website)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Text("نشانی: \(companyInfoManager.companyInfo.address)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    if !companyInfoManager.companyInfo.city.isEmpty {
                        Text("شهر: \(companyInfoManager.companyInfo.city)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                
                // Company Logo (if exists)
                if let logo = imageManager.companyLogo {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .cornerRadius(6)
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.bottom, 15)
    }
    
    // MARK: - Customer Information Section
    private var modernCustomerSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("مشخصات خریدار:")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            VStack(alignment: .trailing, spacing: 8) {
                Text("نام خریدار: \(invoice.customer.name)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                if !invoice.customer.phone.isEmpty {
                    Text("تلفن: \(invoice.customer.phone)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                if !invoice.customer.email.isEmpty {
                    Text("ایمیل: \(invoice.customer.email)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                if !invoice.customer.postalCode.isEmpty {
                    Text("کد پستی: \(invoice.customer.postalCode)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Text("نشانی: \(invoice.customer.address)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                if !invoice.customer.city.isEmpty {
                    Text("شهر: \(invoice.customer.city)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .padding(.bottom, 15)
    }
    
    // MARK: - Items Table Section
    private var modernItemsTableSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("مشخصات کالا یا خدمات:")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            VStack(spacing: 0) {
                // Table Header
                HStack {
                    Text("شرح کالا یا خدمات")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("تعداد")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, alignment: .center)
                    
                    Text("قیمت واحد")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 80, alignment: .center)
                    
                    Text("جمع")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 80, alignment: .center)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.blue)
                .cornerRadius(6, corners: [.topLeft, .topRight])
                
                // Table Rows
                ForEach(Array(invoice.items.enumerated()), id: \.element.id) { index, item in
                    HStack {
                        Text(item.description)
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text(PersianNumberFormatter.shared.toPersian(item.quantity))
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .frame(width: 60, alignment: .center)
                        
                        Text(PersianNumberFormatter.shared.currencyString(from: item.unitPrice, currency: invoice.currency))
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .frame(width: 80, alignment: .center)
                        
                        Text(PersianNumberFormatter.shared.currencyString(from: item.total, currency: invoice.currency))
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                            .frame(width: 80, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(index % 2 == 0 ? Color(.systemBackground) : Color(.systemGray6))
                    
                    if index < invoice.items.count - 1 {
                        Divider()
                            .padding(.horizontal, 12)
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(.systemGray4), lineWidth: 0.5)
            )
        }
        .padding(.bottom, 15)
    }
    
    // MARK: - Totals Section
    private var modernTotalsSection: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                // Subtotal
                HStack {
                    Text(PersianNumberFormatter.shared.toPersian(invoice.subtotal))
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                        .frame(width: 80, alignment: .leading)
                    
                    Text("جمع کل:")
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                }
                
                // Discount (if applicable)
                if invoice.discountRate > 0 {
                    HStack {
                        Text("-\(PersianNumberFormatter.shared.toPersian(invoice.discountAmount))")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .frame(width: 80, alignment: .leading)
                        
                        Text("تخفیف:")
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                    }
                }
                
                // Tax (if applicable)
                if invoice.taxRate > 0 {
                    HStack {
                        Text(PersianNumberFormatter.shared.toPersian(invoice.taxAmount))
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                            .frame(width: 80, alignment: .leading)
                        
                        Text("مالیات:")
                            .font(.system(size: 12))
                            .foregroundColor(.primary)
                    }
                }
                if invoice.taxRate > 0 && invoice.discountRate > 0 {
                Divider()
                
                                 // Final total
                 HStack {
                     Text(PersianNumberFormatter.shared.toPersian(invoice.total))
                         .font(.system(size: 14, weight: .bold))
                         .foregroundColor(.blue)
                         .frame(width: 80, alignment: .leading)
                 }
                }
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .padding(.bottom, 15)
    }
    
    // MARK: - Account Number Section
    private var modernAccountNumberSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("اطلاعات پرداخت:")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            HStack {
                // Number on the left
                Text(invoice.accountNumber)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Title on the right
                Text("شماره حساب یا شماره کارت:")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(12)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green, lineWidth: 1)
            )
        }
        .padding(.bottom, 15)
    }
    
    // MARK: - Notes Section
    private var modernNotesSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("یادداشت:")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text(invoice.notes)
                .font(.system(size: 12))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 1)
                )
        }
        .padding(.bottom, 15)
    }
    
    // MARK: - Footer Section
    private var modernFooterSection: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Divider()
                .padding(.vertical, 8)
            
            HStack {
                // Thank you message
                Text("با تشکر از اعتماد شما")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                // Signature (if exists)
                if let signature = imageManager.signature {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("امضا و مهر:")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Image(uiImage: signature)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 50)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
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
    
    private func generatePDF() {
        Task {
            let data = await PDFGenerator.generateInvoicePDF(invoice: invoice)
            
            DispatchQueue.main.async {
                self.pdfData = data
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

struct PDFKitView: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .vertical
        
        if let document = PDFKit.PDFDocument(data: data) {
            pdfView.document = document
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        if let document = PDFKit.PDFDocument(data: data) {
            uiView.document = document
        }
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

// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    var sampleInvoice = Invoice()
    sampleInvoice.invoiceNumber = "INV-001"
    sampleInvoice.customer.name = "علی احمدی"
    sampleInvoice.customer.email = "ali@example.com"
    sampleInvoice.customer.phone = "09123456789"
    sampleInvoice.customer.address = "خیابان ولیعصر"
    sampleInvoice.customer.city = "تهران"
    sampleInvoice.accountNumber = "1234-5678-9012-3456"
    
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
    sampleInvoice.discountRate = 5
    
    return InvoicePreviewView(invoice: sampleInvoice)
}
