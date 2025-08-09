//
//  PDFGenerator.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
//

import UIKit
import PDFKit

class PDFGenerator {
    
    // MARK: - PDF Color Constants (Always Light)
    private struct PDFColors {
        static let text = UIColor.black
        static let textSecondary = UIColor.darkGray
        static let background = UIColor.white
        static let surface = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0) // Light gray
        static let border = UIColor.black
        static let accent = UIColor.systemBlue
        static let warning = UIColor.orange
        static let success = UIColor.systemGreen
        static let error = UIColor.systemRed
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
                    
                    // MARK: - Helper Functions
                    
                    // Helper function to check if a string is not empty
                    func isNotEmpty(_ string: String) -> Bool {
                        return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    }
                    
                    // Helper function to build conditional text
                    func buildConditionalText(prefix: String, value: String, suffix: String = "") -> String {
                        if isNotEmpty(value) {
                            return "\(prefix) \(value)\(suffix)"
                        }
                        return ""
                    }
                    
                    // Helper function to draw RTL text with proper Persian support
                    func drawText(_ text: String, font: UIFont, color: UIColor = PDFColors.text, alignment: NSTextAlignment = .right, rect: CGRect) {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = alignment
                        paragraphStyle.baseWritingDirection = .rightToLeft
                        paragraphStyle.lineBreakMode = .byWordWrapping
                        
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: font,
                            .foregroundColor: color,
                            .paragraphStyle: paragraphStyle
                        ]
                        
                        let attributedString = NSAttributedString(string: text, attributes: attributes)
                        attributedString.draw(in: rect)
                    }
                    
                    // Helper function for center-aligned text
                    func drawCenterText(_ text: String, font: UIFont, color: UIColor = PDFColors.text, rect: CGRect) {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .center
                        paragraphStyle.baseWritingDirection = .rightToLeft
                        
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: font,
                            .foregroundColor: color,
                            .paragraphStyle: paragraphStyle
                        ]
                        
                        let attributedString = NSAttributedString(string: text, attributes: attributes)
                        attributedString.draw(in: rect)
                    }
                    
                    // Helper function for left-aligned text
                    func drawLeftText(_ text: String, font: UIFont, color: UIColor = PDFColors.text, rect: CGRect) {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .left
                        
                        let attributes: [NSAttributedString.Key: Any] = [
                            .font: font,
                            .foregroundColor: color,
                            .paragraphStyle: paragraphStyle
                        ]
                        
                        let attributedString = NSAttributedString(string: text, attributes: attributes)
                        attributedString.draw(in: rect)
                    }
                    
                    // Helper function to draw images
                    func drawImage(_ image: UIImage, in rect: CGRect) {
                        image.draw(in: rect)
                    }
                    
                    // Helper function to draw rectangles with borders
                    func drawRect(_ rect: CGRect, fillColor: UIColor? = nil, strokeColor: UIColor = PDFColors.border, lineWidth: CGFloat = 1) {
                        if let fillColor = fillColor {
                            fillColor.setFill()
                            UIRectFill(rect)
                        }
                        
                        strokeColor.setStroke()
                        let path = UIBezierPath(rect: rect)
                        path.lineWidth = lineWidth
                        path.stroke()
                    }
                    
                    // Helper function to draw lines
                    func drawLine(from start: CGPoint, to end: CGPoint, color: UIColor = PDFColors.border, width: CGFloat = 1) {
                        color.setStroke()
                        let path = UIBezierPath()
                        path.move(to: start)
                        path.addLine(to: end)
                        path.lineWidth = width
                        path.stroke()
                    }
                    
                    // MARK: - Font Definitions
                    let titleFont = UIFont.boldSystemFont(ofSize: 28)
                    let headerFont = UIFont.boldSystemFont(ofSize: 18)
                    let subHeaderFont = UIFont.boldSystemFont(ofSize: 16)
                    let bodyFont = UIFont.systemFont(ofSize: 12)
                    let boldBodyFont = UIFont.boldSystemFont(ofSize: 12)
                    let smallFont = UIFont.systemFont(ofSize: 10)
                    let totalFont = UIFont.boldSystemFont(ofSize: 14)
                    
                    // MARK: - Header Section (Logo Only)
                    
                    let headerHeight: CGFloat = 80
                    let headerY = yPosition
                    
                    // Company logo (centered)
                    if let logo = imageManager.companyLogo {
                        let logoSize: CGFloat = 60
                        let logoX = (pageSize.width - logoSize) / 2
                        let logoRect = CGRect(x: logoX, y: headerY + 10, width: logoSize, height: logoSize)
                        drawImage(logo, in: logoRect)
                    }
                    
                    yPosition += headerHeight
                    
                    // MARK: - Invoice and Customer Info Section
                    
                    // Invoice info box (top-right)
                    let infoBoxWidth: CGFloat = 200
                    let infoBoxHeight: CGFloat = 80
                    let infoBoxX = pageSize.width - margin - infoBoxWidth
                    
                    drawRect(CGRect(x: infoBoxX, y: yPosition, width: infoBoxWidth, height: infoBoxHeight),
                            fillColor: PDFColors.surface, strokeColor: PDFColors.border)
                    
                    drawText("پیش فاکتور فروش کالا و خدمات", font: boldBodyFont,
                            rect: CGRect(x: infoBoxX + 10, y: yPosition + 10, width: infoBoxWidth - 20, height: 20))
                    
                    drawText("تاریخ: \(PersianDateFormatter.shared.string(from: invoice.date))", font: bodyFont,
                            rect: CGRect(x: infoBoxX + 10, y: yPosition + 30, width: infoBoxWidth - 20, height: 20))
                    
                    drawText("شماره فاکتور: \(invoice.invoiceNumber)", font: bodyFont,
                            rect: CGRect(x: infoBoxX + 10, y: yPosition + 50, width: infoBoxWidth - 20, height: 20))
                    
                    yPosition += infoBoxHeight + 20
                    
                    // Customer information section
                    drawText("مشخصات فروشنده:", font: boldBodyFont,
                            rect: CGRect(x: margin, y: yPosition, width: 150, height: 20))
                    yPosition += 25
                    
                    // Seller info box
                    let sellerBoxHeight: CGFloat = 60
                    drawRect(CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: sellerBoxHeight),
                            fillColor: PDFColors.surface, strokeColor: PDFColors.border)
                    
                    // Build seller info with conditional fields
                    var sellerInfoParts: [String] = []
                    sellerInfoParts.append("نام فرکت یا مجموعه: \(companyInfoManager.companyInfo.name)")
                    
                    if isNotEmpty(companyInfoManager.companyInfo.phone) {
                        sellerInfoParts.append("تلفن: \(companyInfoManager.companyInfo.phone)")
                    }
                    
                    if isNotEmpty(companyInfoManager.companyInfo.email) {
                        sellerInfoParts.append("ایمیل: \(companyInfoManager.companyInfo.email)")
                    }
                    
                    if isNotEmpty(companyInfoManager.companyInfo.website) {
                        sellerInfoParts.append("وب‌سایت: \(companyInfoManager.companyInfo.website)")
                    }
                    
                    let sellerInfo = sellerInfoParts.joined(separator: "    ")
                    drawText(sellerInfo, font: bodyFont,
                            rect: CGRect(x: margin + 10, y: yPosition + 10, width: pageSize.width - 2*margin - 20, height: 20))
                    
                    // Build address info with conditional city
                    var addressInfoParts: [String] = []
                    addressInfoParts.append("نشانی: \(companyInfoManager.companyInfo.address)")
                    
                    if isNotEmpty(companyInfoManager.companyInfo.city) {
                        addressInfoParts.append("شهر: \(companyInfoManager.companyInfo.city)")
                    }
                    
                    let addressInfo = addressInfoParts.joined(separator: "    ")
                    drawText(addressInfo, font: bodyFont,
                            rect: CGRect(x: margin + 10, y: yPosition + 30, width: pageSize.width - 2*margin - 20, height: 20))
                    
                    yPosition += sellerBoxHeight + 15
                    
                    // Customer info section
                    drawText("مشخصات خریدار:", font: boldBodyFont,
                            rect: CGRect(x: margin, y: yPosition, width: 150, height: 20))
                    yPosition += 25
                    
                    let buyerBoxHeight: CGFloat = 60
                    drawRect(CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: buyerBoxHeight),
                            fillColor: PDFColors.surface, strokeColor: PDFColors.border)
                    
                    // Build buyer info with conditional fields
                    var buyerInfoParts: [String] = []
                    buyerInfoParts.append("نام خریدار: \(invoice.customer.name)")
                    
                    if isNotEmpty(invoice.customer.phone) {
                        buyerInfoParts.append("تلفن: \(invoice.customer.phone)")
                    }
                    
                    if isNotEmpty(invoice.customer.email) {
                        buyerInfoParts.append("ایمیل: \(invoice.customer.email)")
                    }
                    
                    if isNotEmpty(invoice.customer.postalCode) {
                        buyerInfoParts.append("کد پستی: \(invoice.customer.postalCode)")
                    }
                    
                    let buyerInfo = buyerInfoParts.joined(separator: "    ")
                    drawText(buyerInfo, font: bodyFont,
                            rect: CGRect(x: margin + 10, y: yPosition + 10, width: pageSize.width - 2*margin - 20, height: 20))
                    
                    // Build buyer address with conditional city
                    var buyerAddressParts: [String] = []
                    buyerAddressParts.append("نشانی: \(invoice.customer.address)")
                    
                    if isNotEmpty(invoice.customer.city) {
                        buyerAddressParts.append("شهر: \(invoice.customer.city)")
                    }
                    
                    let buyerAddress = buyerAddressParts.joined(separator: ", ")
                    drawText(buyerAddress, font: bodyFont,
                            rect: CGRect(x: margin + 10, y: yPosition + 30, width: pageSize.width - 2*margin - 20, height: 20))
                    
                    yPosition += buyerBoxHeight + 20
                    
                    // MARK: - Items Table
                    
                    drawText("مشخصات کالا یا خدمات:", font: boldBodyFont,
                            rect: CGRect(x: margin, y: yPosition, width: 200, height: 20))
                    yPosition += 25
                    
                    let tableStartY = yPosition
                    let rowHeight: CGFloat = 30
                    let colWidths: [CGFloat] = [275, 60, 80, 80] // Description, Quantity, Unit Price, Total
                    
                    // Table header
                    let headerRect = CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: rowHeight)
                    drawRect(headerRect, fillColor: PDFColors.surface, strokeColor: PDFColors.border, lineWidth: 1)
                    
                    var xPos = margin + 5
                    drawText("شرح کالا یا خدمات", font: boldBodyFont, color: PDFColors.text,
                            rect: CGRect(x: xPos + 5, y: yPosition + 8, width: colWidths[0] - 10, height: 15))
                    
                    xPos += colWidths[0]
                    drawCenterText("تعداد", font: boldBodyFont, color: PDFColors.text,
                                  rect: CGRect(x: xPos, y: yPosition + 8, width: colWidths[1] - 10, height: 15))
                    
                    xPos += colWidths[1]
                    drawCenterText("قیمت واحد", font: boldBodyFont, color: PDFColors.text,
                                  rect: CGRect(x: xPos, y: yPosition + 8, width: colWidths[2] - 10, height: 15))
                    
                    xPos += colWidths[2]
                    drawCenterText("جمع", font: boldBodyFont, color: PDFColors.text,
                                  rect: CGRect(x: xPos, y: yPosition + 8, width: colWidths[3] - 10, height: 15))
                    
                    yPosition += rowHeight
                    
                    // Table rows
                    for (index, item) in invoice.items.enumerated() {
                        let rowRect = CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: rowHeight)
                        drawRect(rowRect, strokeColor: PDFColors.textSecondary)
                        
                        xPos = margin + 5
                        drawText(item.description, font: bodyFont, color: PDFColors.text,
                                rect: CGRect(x: xPos + 5, y: yPosition + 8, width: colWidths[0] - 10, height: 15))
                        
                        xPos += colWidths[0]
                        drawCenterText(PersianNumberFormatter.shared.toPersian(item.quantity), 
                                      font: bodyFont, color: PDFColors.text, rect: CGRect(x: xPos, y: yPosition + 8, width: colWidths[1] - 10, height: 15))
                        
                        xPos += colWidths[1]
                        drawCenterText(PersianNumberFormatter.shared.currencyString(from: item.unitPrice, currency: invoice.currency), 
                                      font: bodyFont, color: PDFColors.text, rect: CGRect(x: xPos, y: yPosition + 8, width: colWidths[2] - 10, height: 15))
                        
                        xPos += colWidths[2]
                        drawCenterText(PersianNumberFormatter.shared.currencyString(from: item.total, currency: invoice.currency), 
                                      font: bodyFont, color: PDFColors.text, rect: CGRect(x: xPos, y: yPosition + 8, width: colWidths[3] - 10, height: 15))
                        
                        yPosition += rowHeight
                    }
                    
                    // Table bottom border
                    drawLine(from: CGPoint(x: margin, y: yPosition),
                            to: CGPoint(x: pageSize.width - margin, y: yPosition),
                            color: PDFColors.border, width: 1)
                    
                    yPosition += 25
                    
                    // MARK: - Totals Section (Simple)
                    
                    // Add some space before totals
                    yPosition += 20
                    
                    // Simple totals in bottom right, similar to template
                    let totalsX = pageSize.width - margin - 200
                    
                    // Subtotal
                    drawText(PersianNumberFormatter.shared.currencyString(from: invoice.subtotal, currency: invoice.currency), 
                            font: bodyFont, color: PDFColors.text, rect: CGRect(x: totalsX, y: yPosition, width: 90, height: 20))
                    drawText("جمع کل:", font: bodyFont, color: PDFColors.text,
                            rect: CGRect(x: totalsX + 100, y: yPosition, width: 90, height: 20))
                    yPosition += 25
                    
                    // Discount (if applicable)
                    if invoice.discountRate > 0 {
                        drawText("-\(PersianNumberFormatter.shared.currencyString(from: invoice.discountAmount, currency: invoice.currency))", 
                                font: bodyFont, color: PDFColors.text, rect: CGRect(x: totalsX, y: yPosition, width: 90, height: 20))
                        drawText("تخفیف:", font: bodyFont, color: PDFColors.text,
                                rect: CGRect(x: totalsX + 100, y: yPosition, width: 90, height: 20))
                        yPosition += 25
                    }
                    
                    // Tax (if applicable)
                    if invoice.taxRate > 0 {
                        drawText(PersianNumberFormatter.shared.currencyString(from: invoice.taxAmount, currency: invoice.currency), 
                                font: bodyFont, color: PDFColors.text, rect: CGRect(x: totalsX, y: yPosition, width: 90, height: 20))
                        drawText("مالیات:", font: bodyFont, color: PDFColors.text,
                                rect: CGRect(x: totalsX + 100, y: yPosition, width: 90, height: 20))
                        yPosition += 25
                    }
                    
                    // Final total
                    drawText(PersianNumberFormatter.shared.currencyString(from: invoice.total, currency: invoice.currency), 
                            font: boldBodyFont, color: PDFColors.text, rect: CGRect(x: totalsX, y: yPosition, width: 90, height: 20))
                    drawText("مبلغ قابل پرداخت:", font: boldBodyFont, color: PDFColors.text,
                            rect: CGRect(x: totalsX + 100, y: yPosition, width: 90, height: 20))
                    
                    yPosition += 40
                    
                    // MARK: - Notes Section
                    if !invoice.notes.isEmpty {
                        drawText("یادداشت:", font: subHeaderFont, color: PDFColors.text,
                                rect: CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: 20))
                        yPosition += 25
                        
                        let notesHeight: CGFloat = 50
                        drawRect(CGRect(x: margin, y: yPosition, width: pageSize.width - 2*margin, height: notesHeight),
                                fillColor: PDFColors.warning.withAlphaComponent(0.1), strokeColor: PDFColors.warning)
                        
                        drawText(invoice.notes, font: bodyFont, color: PDFColors.text,
                                rect: CGRect(x: margin + 10, y: yPosition + 10, width: pageSize.width - 2*margin - 20, height: notesHeight - 20))
                        yPosition += notesHeight + 20
                    }
                    
                    // MARK: - Footer Section
                    
                    // Push footer to bottom if there's space
                    let footerHeight: CGFloat = 80
                    let minFooterY = pageSize.height - footerHeight - 20
                    if yPosition < minFooterY {
                        yPosition = minFooterY
                    }
                    
                    // Footer separator line
                    drawLine(from: CGPoint(x: margin, y: yPosition),
                            to: CGPoint(x: pageSize.width - margin, y: yPosition),
                            color: PDFColors.border, width: 1)
                    yPosition += 15
                    
                    // Signature section
                    if let signature = imageManager.signature {
                        let signatureWidth: CGFloat = 120
                        let signatureHeight: CGFloat = 50
                        let signatureX = pageSize.width - margin - signatureWidth - 20
                        
                        drawText("امضا و مهر:", font: boldBodyFont, color: PDFColors.text,
                                rect: CGRect(x: signatureX, y: yPosition, width: signatureWidth, height: 20))
                        
                        let signatureRect = CGRect(x: signatureX, y: yPosition + 25, width: signatureWidth, height: signatureHeight)
                        
                        // Draw signature without border
                        drawImage(signature, in: signatureRect)
                    }
                    
                    // Thank you message
                    drawText("با تشکر از اعتماد شما", font: bodyFont, color: PDFColors.textSecondary,
                            rect: CGRect(x: margin, y: yPosition + 35, width: 200, height: 20))
                    
                    // Page number (if needed for multi-page invoices in future)
                    drawCenterText("صفحه ۱", font: smallFont, color: PDFColors.textSecondary,
                                  rect: CGRect(x: margin, y: pageSize.height - 25, width: pageSize.width - 2*margin, height: 15))
                }
                
                continuation.resume(returning: data)
            }
        }
    }
}