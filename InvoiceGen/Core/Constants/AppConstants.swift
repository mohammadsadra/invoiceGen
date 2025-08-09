import Foundation

struct AppConstants {
    
    // MARK: - App Information
    struct App {
        static let name = "InvoiceGen"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }
    
    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        static let buttonHeight: CGFloat = 50
        static let textFieldHeight: CGFloat = 44
    }
    
    // MARK: - Storage Keys
    struct StorageKeys {
        static let invoices = "invoices"
        static let customers = "customers"
        static let companyInfo = "companyInfo"
        static let settings = "settings"
    }
    
    // MARK: - File Extensions
    struct FileExtensions {
        static let pdf = "pdf"
        static let json = "json"
    }
    
    // MARK: - Date Formats
    struct DateFormats {
        static let display = "MMM dd, yyyy"
        static let invoice = "yyyy-MM-dd"
        static let filename = "yyyy-MM-dd-HH-mm-ss"
    }
    
    // MARK: - Validation
    struct Validation {
        static let maxInvoiceNumberLength = 50
        static let maxCustomerNameLength = 100
        static let maxCompanyNameLength = 100
        static let maxDescriptionLength = 500
    }
}
