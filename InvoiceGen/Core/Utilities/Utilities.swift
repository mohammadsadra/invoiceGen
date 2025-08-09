//
//  Utilities.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
//

import SwiftUI
import Foundation

// MARK: - Persian Date Formatter
struct PersianDateFormatter {
    static let shared = PersianDateFormatter()
    
    private let persianCalendar: Calendar
    private let persianFormatter: DateFormatter
    
    init() {
        var calendar = Calendar(identifier: .persian)
        calendar.locale = Locale(identifier: "fa_IR")
        persianCalendar = calendar
        
        persianFormatter = DateFormatter()
        persianFormatter.calendar = persianCalendar
        persianFormatter.locale = Locale(identifier: "fa_IR")
    }
    
    func string(from date: Date, style: DateFormatter.Style = .medium) -> String {
        persianFormatter.dateStyle = style
        persianFormatter.timeStyle = .none
        return persianFormatter.string(from: date)
    }
    
    func shortString(from date: Date) -> String {
        persianFormatter.dateStyle = .short
        persianFormatter.timeStyle = .none
        return persianFormatter.string(from: date)
    }
    
    func longString(from date: Date) -> String {
        persianFormatter.dateStyle = .full
        persianFormatter.timeStyle = .none
        return persianFormatter.string(from: date)
    }
}

// MARK: - Font Extensions
extension Font {
    static func vazirmatn(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Vazirmatn", size: size).weight(weight)
    }
    
    static let vazirmatenTitle = Font.vazirmatn(24, weight: .bold)
    static let vazirmatenHeadline = Font.vazirmatn(18, weight: .semibold)
    static let vazirmatenBody = Font.vazirmatn(16)
    static let vazirmatenCaption = Font.vazirmatn(14)
    static let vazirmatenSmall = Font.vazirmatn(12)
}

// MARK: - Persian Number Formatter
struct PersianNumberFormatter {
    static let shared = PersianNumberFormatter()
    
    private let persianDigits = ["۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹"]
    private let englishDigits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    func toPersian(_ number: String) -> String {
        var result = number
        for (index, englishDigit) in englishDigits.enumerated() {
            result = result.replacingOccurrences(of: englishDigit, with: persianDigits[index])
        }
        return result
    }
    
    func toPersian(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "fa_IR")
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    func currencyString(from amount: Double) -> String {
        return currencyString(from: amount, currency: .rial) // Default to Rial for backward compatibility
    }
    
    func currencyString(from amount: Double, currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.maximumFractionDigits = 0
        
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "\(formattedAmount) \(currency.displayName)"
    }
}

// MARK: - RTL Layout Modifier
struct RTLModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(\.layoutDirection, .rightToLeft)
            .flipsForRightToLeftLayoutDirection(true)
    }
}

extension View {
    func rtlLayout() -> some View {
        self.modifier(RTLModifier())
    }
}
