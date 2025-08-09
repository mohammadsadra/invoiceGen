import Foundation

struct AppConfig {
    
    // MARK: - Environment
    enum Environment: String {
        case development = "development"
        case staging = "staging"
        case production = "production"
        
        static var current: Environment {
            #if DEBUG
            return .development
            #else
            return .production
            #endif
        }
    }
    
    // MARK: - API Configuration
    struct API {
        static let baseURL: String = {
            switch Environment.current {
            case .development:
                return "https://api-dev.invoicegen.com"
            case .staging:
                return "https://api-staging.invoicegen.com"
            case .production:
                return "https://api.invoicegen.com"
            }
        }()
        
        static let timeoutInterval: TimeInterval = 30
        static let maxRetries = 3
    }
    
    // MARK: - Feature Flags
    struct Features {
        static let enableAnalytics = true
        static let enableCrashReporting = true
        static let enablePushNotifications = true
        static let enableCloudSync = false // For future implementation
    }
    
    // MARK: - Storage Configuration
    struct Storage {
        static let maxInvoiceCount = 1000
        static let maxCustomerCount = 500
        static let autoBackupEnabled = true
        static let backupInterval: TimeInterval = 24 * 60 * 60 // 24 hours
    }
    
    // MARK: - UI Configuration
    struct UI {
        static let enableAnimations = true
        static let enableHapticFeedback = true
        static let defaultCurrency = "USD"
        static let defaultDateFormat = "MMM dd, yyyy"
    }
    
    // MARK: - Validation Rules
    struct Validation {
        static let minInvoiceAmount: Double = 0.01
        static let maxInvoiceAmount: Double = 999999.99
        static let maxInvoiceItems = 100
        static let maxCustomerNameLength = 100
        static let maxCompanyNameLength = 100
    }
}
