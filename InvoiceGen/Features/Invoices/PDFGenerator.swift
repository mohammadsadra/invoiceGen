//
//  PDFGenerator.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import UIKit
import PDFKit

class PDFGenerator {
    
    // MARK: - Modern PDF Color Scheme
    private struct ModernPDFColors {
        static let primary = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0) // Dark gray
        static let secondary = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0) // Medium gray
        static let background = UIColor.white
        static let surface = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0) // Light gray
        static let border = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) // Light border
        static let accent = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // Blue
        static let success = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0) // Green
        static let warning = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0) // Orange
        static let error = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0) // Red
        static let text = UIColor.black
        static let textSecondary = UIColor.darkGray
    }
    
    // MARK: - Modern Font Definitions
    private struct ModernFonts {
        static let title = UIFont.boldSystemFont(ofSize: 32)
        static let header = UIFont.boldSystemFont(ofSize: 20)
        static let subHeader = UIFont.boldSystemFont(ofSize: 16)
        static let body = UIFont.systemFont(ofSize: 14)
        static let bodyBold = UIFont.boldSystemFont(ofSize: 14)
        static let caption = UIFont.systemFont(ofSize: 12)
        static let captionBold = UIFont.boldSystemFont(ofSize: 12)
        static let small = UIFont.systemFont(ofSize: 10)
        static let total = UIFont.boldSystemFont(ofSize: 16)
    }
    
    static func generateInvoicePDF(invoice: Invoice) async -> Data {
        let imageManager = ImageStorageManager.shared
        let companyInfoManager = CompanyInfoManager.shared
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let pageSize = CGSize(width: 595, height: 842) // A4 size in points
                let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
                
                let data = renderer.pdfData { context in
                    context.beginPage()
                    
                    let margin: CGFloat = 40
                    var yPosition: CGFloat = 30
                    
                    // MARK: - RTL Helper Functions
                    
                    func isNotEmpty(_ string: String) -> Bool {
                        return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    }
                    
                    func drawRTLText(_ text: String, font: UIFont, color: UIColor = ModernPDFColors.text, alignment: NSTextAlignment = .right, rect: CGRect) {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = alignment
                        paragraphStyle.baseWritingDirection = .rightToLeft
                        paragraphStyle.lineBreakMode = .byWordWrapping
                        paragraphStyle.lineSpacing = 2
                        
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: font,
                            .foregroundColor: color,
                            .paragraphStyle: paragraphStyle
                        ]
                        
                        let attributedString = NSAttributedString(string: text, attributes: attributes)
                        attributedString.draw(in: rect)
                    }
                    
                    func drawRTLCenterText(_ text: String, font: UIFont, color: UIColor = ModernPDFColors.text, rect: CGRect) {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .center
                        paragraphStyle.baseWritingDirection = .rightToLeft
                        paragraphStyle.lineBreakMode = .byWordWrapping
                        paragraphStyle.lineSpacing = 2
                        
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: font,
                            .foregroundColor: color,
                            .paragraphStyle: paragraphStyle
                        ]
                        
                        let attributedString = NSAttributedString(string: text, attributes: attributes)
                        attributedString.draw(in: rect)
                    }
                    
                    func drawImage(_ image: UIImage, in rect: CGRect) {
                        image.draw(in: rect)
                    }
                    
                    func drawRect(_ rect: CGRect, fillColor: UIColor? = nil, strokeColor: UIColor = ModernPDFColors.border, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8) {
                        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
                        
                        if let fillColor = fillColor {
                            fillColor.setFill()
                            path.fill()
                        }
                        
                        strokeColor.setStroke()
                        path.lineWidth = lineWidth
                        path.stroke()
                    }
                    
                    func drawLine(from start: CGPoint, to end: CGPoint, color: UIColor = ModernPDFColors.border, width: CGFloat = 1) {
                        color.setStroke()
                        let path = UIBezierPath()
                        path.move(to: start)
                        path.addLine(to: end)
                        path.lineWidth = width
                        path.stroke()
                    }
                    
                    // MARK: - Header Section (Title on the right)
                    
                    let headerHeight: CGFloat = 80
                    let headerY = yPosition
                    
                    // Title on the right side
                    let titleText = "پیش فاکتور"
                    let titleRect = CGRect(x: margin, y: headerY, width: pageSize.width - 2*margin, height: headerHeight)
                    drawRTLText(titleText, font: ModernFonts.title, color: ModernPDFColors.primary, alignment: .right, rect: titleRect)
                    
                    yPosition += headerHeight + 20
                    
                    // MARK: - Invoice Info Section (Right-aligned)
                    
                    let infoCardWidth: CGFloat = 250
                    let infoCardHeight: CGFloat = 80
                    let infoCardX = pageSize.width - margin - infoCardWidth
                    
                    drawRect(CGRect(x: infoCardX, y: yPosition, width: infoCardWidth, height: infoCardHeight),
                           fillColor: ModernPDFColors.surface, strokeColor: ModernPDFColors.border, lineWidth: 1, cornerRadius: 12)
                    
                    drawRTLText("تاریخ: \(PersianDateFormatter.shared.string(from: invoice.date))", font: ModernFonts.body,
                              rect: CGRect(x: infoCardX + 15, y: yPosition + 15, width: infoCardWidth - 30, height: 20))
                    
                    drawRTLText("شماره فاکتور: \(invoice.invoiceNumber)", font: ModernFonts.body,
                              rect: CGRect(x: infoCardX + 15, y: yPosition + 40, width: infoCardWidth - 30, height: 20))
                    
                    yPosition += infoCardHeight + 25
                    
                    // MARK: - Company Information Section (with conditional logo)
                    
                    drawRTLText("مشخصات فروشنده:", font: ModernFonts.subHeader, color: ModernPDFColors.primary, alignment: .right,
                              rect: CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: 25))
                    yPosition += 30
                    
                    // Check if company logo exists
                    let hasLogo = imageManager.companyLogo != nil
                    let logoSize: CGFloat = hasLogo ? 60 : 0
                    let logoSpacing: CGFloat = hasLogo ? 20 : 0
                    
                    let companyCardHeight: CGFloat = 100
                    let companyCardWidth = pageSize.width - 2*margin
                    drawRect(CGRect(x: margin, y: yPosition, width: companyCardWidth, height: companyCardHeight),
                           fillColor: ModernPDFColors.surface, strokeColor: ModernPDFColors.border, lineWidth: 1, cornerRadius: 12)
                    
                    // Company logo (right side if exists)
                    if let logo = imageManager.companyLogo {
                        let logoX = pageSize.width - margin - logoSize - 15
                        let logoY = yPosition + 20
                        let logoRect = CGRect(x: logoX, y: logoY, width: logoSize, height: logoSize)
                        drawImage(logo, in: logoRect)
                    }
                    
                    // Company info (left side of logo, or full width if no logo)
                    let infoStartX = margin + 15
                    let infoWidth = hasLogo ? (companyCardWidth - logoSize - logoSpacing - 30) : (companyCardWidth - 30)
                    
                    // Build company info with conditional fields
                    var companyInfoParts: [String] = []
                    companyInfoParts.append("نام شرکت: \(companyInfoManager.companyInfo.name)")
                    
                    if isNotEmpty(companyInfoManager.companyInfo.phone) {
                        companyInfoParts.append("تلفن: \(companyInfoManager.companyInfo.phone)")
                    }
                    
                    if isNotEmpty(companyInfoManager.companyInfo.email) {
                        companyInfoParts.append("ایمیل: \(companyInfoManager.companyInfo.email)")
                    }
                    
                    if isNotEmpty(companyInfoManager.companyInfo.website) {
                        companyInfoParts.append("وب‌سایت: \(companyInfoManager.companyInfo.website)")
                    }
                    
                    let companyInfo = companyInfoParts.joined(separator: "    ")
                    drawRTLText(companyInfo, font: ModernFonts.body,
                              rect: CGRect(x: infoStartX, y: yPosition + 15, width: infoWidth, height: 20))
                    
                    // Build address info with conditional city
                    var addressInfoParts: [String] = []
                    addressInfoParts.append("نشانی: \(companyInfoManager.companyInfo.address)")
                    
                    if isNotEmpty(companyInfoManager.companyInfo.city) {
                        addressInfoParts.append("شهر: \(companyInfoManager.companyInfo.city)")
                    }
                    
                    let addressInfo = addressInfoParts.joined(separator: "    ")
                    drawRTLText(addressInfo, font: ModernFonts.body,
                              rect: CGRect(x: infoStartX, y: yPosition + 45, width: infoWidth, height: 20))
                    
                    yPosition += companyCardHeight + 20
                    
                    // MARK: - Customer Information Section
                    
                    drawRTLText("مشخصات خریدار:", font: ModernFonts.subHeader, color: ModernPDFColors.primary, alignment: .right,
                              rect: CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: 25))
                    yPosition += 30
                    
                    let customerCardHeight: CGFloat = 80
                    drawRect(CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: customerCardHeight),
                           fillColor: ModernPDFColors.surface, strokeColor: ModernPDFColors.border, lineWidth: 1, cornerRadius: 12)
                    
                    // Build customer info with conditional fields
                    var customerInfoParts: [String] = []
                    customerInfoParts.append("نام خریدار: \(invoice.customer.name)")
                    
                    if isNotEmpty(invoice.customer.phone) {
                        customerInfoParts.append("تلفن: \(invoice.customer.phone)")
                    }
                    
                    if isNotEmpty(invoice.customer.email) {
                        customerInfoParts.append("ایمیل: \(invoice.customer.email)")
                    }
                    
                    if isNotEmpty(invoice.customer.postalCode) {
                        customerInfoParts.append("کد پستی: \(invoice.customer.postalCode)")
                    }
                    
                    let customerInfo = customerInfoParts.joined(separator: "    ")
                    drawRTLText(customerInfo, font: ModernFonts.body,
                              rect: CGRect(x: margin + 15, y: yPosition + 15, width: pageSize.width - 2*margin - 30, height: 20))
                    
                    // Build customer address with conditional city
                    var customerAddressParts: [String] = []
                    customerAddressParts.append("نشانی: \(invoice.customer.address)")
                    
                    if isNotEmpty(invoice.customer.city) {
                        customerAddressParts.append("شهر: \(invoice.customer.city)")
                    }
                    
                    let customerAddress = customerAddressParts.joined(separator: ", ")
                    drawRTLText(customerAddress, font: ModernFonts.body,
                              rect: CGRect(x: margin + 15, y: yPosition + 45, width: pageSize.width - 2*margin - 30, height: 20))
                    
                    yPosition += customerCardHeight + 25
                    
                    // MARK: - Items Table Section
                    
                    drawRTLText("مشخصات کالا یا خدمات:", font: ModernFonts.subHeader, color: ModernPDFColors.primary, alignment: .right,
                              rect: CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: 25))
                    yPosition += 30
                    
                    let rowHeight: CGFloat = 35
                    let availableWidth = pageSize.width - 2*margin
                    let colWidths: [CGFloat] = [
                        availableWidth * 0.55, // Description (55%)
                        availableWidth * 0.15, // Quantity (15%)
                        availableWidth * 0.15, // Unit Price (15%)
                        availableWidth * 0.15  // Total (15%)
                    ]
                    
                    // Table header
                    let tableHeaderRect = CGRect(x: margin, y: yPosition, width: availableWidth, height: rowHeight)
                    drawRect(tableHeaderRect, fillColor: ModernPDFColors.accent, strokeColor: ModernPDFColors.accent, lineWidth: 1, cornerRadius: 8)
                    
                    var xPos = margin + 10
                    drawRTLText("شرح کالا یا خدمات", font: ModernFonts.bodyBold, color: ModernPDFColors.background, alignment: .right,
                              rect: CGRect(x: xPos, y: yPosition + 10, width: colWidths[0] - 20, height: 15))
                    
                    xPos += colWidths[0]
                    drawRTLCenterText("تعداد", font: ModernFonts.bodyBold, color: ModernPDFColors.background,
                                    rect: CGRect(x: xPos, y: yPosition + 10, width: colWidths[1] - 20, height: 15))
                    
                    xPos += colWidths[1]
                    drawRTLCenterText("قیمت واحد", font: ModernFonts.bodyBold, color: ModernPDFColors.background,
                                    rect: CGRect(x: xPos, y: yPosition + 10, width: colWidths[2] - 20, height: 15))
                    
                    xPos += colWidths[2]
                    drawRTLCenterText("جمع", font: ModernFonts.bodyBold, color: ModernPDFColors.background,
                                    rect: CGRect(x: xPos, y: yPosition + 10, width: colWidths[3] - 20, height: 15))
                    
                    yPosition += rowHeight
                    
                    // Table rows
                    for (index, item) in invoice.items.enumerated() {
                        let rowRect = CGRect(x: margin, y: yPosition, width: availableWidth, height: rowHeight)
                        let fillColor = index % 2 == 0 ? ModernPDFColors.background : ModernPDFColors.surface
                        drawRect(rowRect, fillColor: fillColor, strokeColor: ModernPDFColors.border, lineWidth: 0.5, cornerRadius: 4)
                        
                        xPos = margin + 10
                        drawRTLText(item.description, font: ModernFonts.body, color: ModernPDFColors.text, alignment: .right,
                                  rect: CGRect(x: xPos, y: yPosition + 10, width: colWidths[0] - 20, height: 15))
                        
                        xPos += colWidths[0]
                        drawRTLCenterText(PersianNumberFormatter.shared.toPersian(item.quantity), 
                                        font: ModernFonts.body, color: ModernPDFColors.text,
                                        rect: CGRect(x: xPos, y: yPosition + 10, width: colWidths[1] - 20, height: 15))
                        
                        xPos += colWidths[1]
                        drawRTLCenterText(PersianNumberFormatter.shared.currencyString(from: item.unitPrice, currency: invoice.currency), 
                                        font: ModernFonts.body, color: ModernPDFColors.text,
                                        rect: CGRect(x: xPos, y: yPosition + 10, width: colWidths[2] - 20, height: 15))
                        
                        xPos += colWidths[2]
                        drawRTLCenterText(PersianNumberFormatter.shared.currencyString(from: item.total, currency: invoice.currency), 
                                        font: ModernFonts.body, color: ModernPDFColors.text,
                                        rect: CGRect(x: xPos, y: yPosition + 10, width: colWidths[3] - 20, height: 15))
                        
                        yPosition += rowHeight
                    }
                    
                    yPosition += 25
                    
                    // MARK: - Totals Section
                    
                    let totalsCardWidth: CGFloat = 250
                    let totalsCardHeight: CGFloat = 120
                    let totalsCardX = pageSize.width - margin - totalsCardWidth
                    
                    drawRect(CGRect(x: totalsCardX, y: yPosition, width: totalsCardWidth, height: totalsCardHeight),
                           fillColor: ModernPDFColors.surface, strokeColor: ModernPDFColors.border, lineWidth: 1, cornerRadius: 12)
                    
                    var totalY = yPosition + 15
                    
                    // Subtotal
                    drawRTLText(PersianNumberFormatter.shared.currencyString(from: invoice.subtotal, currency: invoice.currency), 
                              font: ModernFonts.body, color: ModernPDFColors.text, alignment: .right,
                              rect: CGRect(x: totalsCardX + 15, y: totalY, width: 100, height: 20))
                    drawRTLText("جمع کل:", font: ModernFonts.body, color: ModernPDFColors.text, alignment: .right,
                              rect: CGRect(x: totalsCardX + 130, y: totalY, width: 100, height: 20))
                    totalY += 25
                    
                    // Discount (if applicable)
                    if invoice.discountRate > 0 {
                        drawRTLText("-\(PersianNumberFormatter.shared.currencyString(from: invoice.discountAmount, currency: invoice.currency))", 
                                  font: ModernFonts.body, color: ModernPDFColors.error, alignment: .right,
                                  rect: CGRect(x: totalsCardX + 15, y: totalY, width: 100, height: 20))
                        drawRTLText("تخفیف:", font: ModernFonts.body, color: ModernPDFColors.text, alignment: .right,
                                  rect: CGRect(x: totalsCardX + 130, y: totalY, width: 100, height: 20))
                        totalY += 25
                    }
                    
                    // Tax (if applicable)
                    if invoice.taxRate > 0 {
                        drawRTLText(PersianNumberFormatter.shared.currencyString(from: invoice.taxAmount, currency: invoice.currency), 
                                  font: ModernFonts.body, color: ModernPDFColors.warning, alignment: .right,
                                  rect: CGRect(x: totalsCardX + 15, y: totalY, width: 100, height: 20))
                        drawRTLText("مالیات:", font: ModernFonts.body, color: ModernPDFColors.text, alignment: .right,
                                  rect: CGRect(x: totalsCardX + 130, y: totalY, width: 100, height: 20))
                        totalY += 25
                    }
                    
                    // Final total
                    drawRTLText(PersianNumberFormatter.shared.currencyString(from: invoice.total, currency: invoice.currency), 
                              font: ModernFonts.total, color: ModernPDFColors.accent, alignment: .right,
                              rect: CGRect(x: totalsCardX + 15, y: totalY, width: 100, height: 25))
                    drawRTLText("مبلغ قابل پرداخت:", font: ModernFonts.total, color: ModernPDFColors.primary, alignment: .right,
                              rect: CGRect(x: totalsCardX + 130, y: totalY, width: 100, height: 25))
                    
                    yPosition += totalsCardHeight + 25
                    
                    // MARK: - Notes Section
                    if !invoice.notes.isEmpty {
                        drawRTLText("یادداشت:", font: ModernFonts.subHeader, color: ModernPDFColors.primary, alignment: .right,
                                  rect: CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: 25))
                        yPosition += 30
                        
                        let notesHeight: CGFloat = 60
                        drawRect(CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: notesHeight),
                               fillColor: ModernPDFColors.warning.withAlphaComponent(0.1), strokeColor: ModernPDFColors.warning, lineWidth: 1, cornerRadius: 12)
                        
                        drawRTLText(invoice.notes, font: ModernFonts.body, color: ModernPDFColors.text, alignment: .right,
                                  rect: CGRect(x: margin + 15, y: yPosition + 15, width: pageSize.width - 2*margin - 30, height: notesHeight - 30))
                        yPosition += notesHeight + 25
                    }
                    
                    // MARK: - Footer Section
                    
                    let footerHeight: CGFloat = 100
                    let minFooterY = pageSize.height - footerHeight - 30
                    if yPosition < minFooterY {
                        yPosition = minFooterY
                    }
                    
                    // Footer separator
                    drawLine(from: CGPoint(x: margin, y: yPosition),
                            to: CGPoint(x: pageSize.width - margin, y: yPosition),
                            color: ModernPDFColors.border, width: 2)
                    yPosition += 20
                    
                    // Signature section
                    if let signature = imageManager.signature {
                        let signatureWidth: CGFloat = 140
                        let signatureHeight: CGFloat = 60
                        let signatureX = pageSize.width - margin - signatureWidth - 20
                        
                        drawRTLText("امضا و مهر:", font: ModernFonts.bodyBold, color: ModernPDFColors.primary, alignment: .right,
                                  rect: CGRect(x: signatureX, y: yPosition, width: signatureWidth, height: 25))
                        
                        let signatureRect = CGRect(x: signatureX, y: yPosition + 30, width: signatureWidth, height: signatureHeight)
                        drawRect(signatureRect, strokeColor: ModernPDFColors.border, lineWidth: 1, cornerRadius: 8)
                        drawImage(signature, in: signatureRect)
                    }
                    
                    // Thank you message
                    drawRTLText("با تشکر از اعتماد شما", font: ModernFonts.body, color: ModernPDFColors.secondary, alignment: .right,
                              rect: CGRect(x: margin, y: yPosition + 40, width: 250, height: 25))
                    
                    // Page number
                    drawRTLCenterText("صفحه ۱", font: ModernFonts.small, color: ModernPDFColors.secondary,
                                    rect: CGRect(x: margin, y: pageSize.height - 30, width: pageSize.width - 2*margin, height: 20))
                }
                
                continuation.resume(returning: data)
            }
        }
    }
}