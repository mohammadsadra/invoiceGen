import Foundation

protocol StorageProtocol {
    func save<T: Codable>(_ object: T, forKey key: String) throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?
    func delete(forKey key: String) throws
    func exists(forKey key: String) -> Bool
}

protocol StorageManagerProtocol {
    var storage: StorageProtocol { get }
    
    func saveInvoices(_ invoices: [Invoice]) throws
    func loadInvoices() throws -> [Invoice]
    func saveCustomers(_ customers: [Customer]) throws
    func loadCustomers() throws -> [Customer]
    func saveCompanyInfo(_ companyInfo: CompanyInfo) throws
    func loadCompanyInfo() throws -> CompanyInfo?
}
