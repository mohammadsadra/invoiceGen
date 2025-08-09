import Foundation

enum InvoiceStatus: String, CaseIterable, Codable {
    case draft = "draft"
    case sent = "sent"
    case paid = "paid"
    case overdue = "overdue"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .draft:
            return "Draft"
        case .sent:
            return "Sent"
        case .paid:
            return "Paid"
        case .overdue:
            return "Overdue"
        case .cancelled:
            return "Cancelled"
        }
    }
    
    var color: String {
        switch self {
        case .draft:
            return "gray"
        case .sent:
            return "blue"
        case .paid:
            return "green"
        case .overdue:
            return "red"
        case .cancelled:
            return "orange"
        }
    }
}
