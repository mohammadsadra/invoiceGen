//
//  CompanyInfoManager.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import Foundation

struct CompanyInformation: Codable {
    var name: String = "شرکت شما"
    var address: String = "آدرس شرکت"
    var city: String = "شهر، کشور"
    var phone: String = "تلفن: ۰۹۱۲۳۴۵۶۷۸۹"
    var email: String = "info@company.com"
    var website: String = "www.company.com"
}

class CompanyInfoManager: ObservableObject {
    static let shared = CompanyInfoManager()
    
    @Published var companyInfo = CompanyInformation()
    
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var companyInfoURL: URL {
        return documentsPath.appendingPathComponent("CompanyInfo.json")
    }
    
    private init() {
        loadCompanyInfo()
    }
    
    // MARK: - Save Company Info
    func saveCompanyInfo(_ info: CompanyInformation) {
        companyInfo = info
        saveToFile()
    }
    
    func updateCompanyInfo(name: String? = nil, address: String? = nil, city: String? = nil, phone: String? = nil, email: String? = nil, website: String? = nil) {
        if let name = name { companyInfo.name = name }
        if let address = address { companyInfo.address = address }
        if let city = city { companyInfo.city = city }
        if let phone = phone { companyInfo.phone = phone }
        if let email = email { companyInfo.email = email }
        if let website = website { companyInfo.website = website }
        
        saveToFile()
    }
    
    // MARK: - Private Methods
    private func saveToFile() {
        do {
            let data = try JSONEncoder().encode(companyInfo)
            try data.write(to: companyInfoURL)
            print("Company info saved successfully")
        } catch {
            print("Failed to save company info: \(error)")
        }
    }
    
    private func loadCompanyInfo() {
        do {
            let data = try Data(contentsOf: companyInfoURL)
            companyInfo = try JSONDecoder().decode(CompanyInformation.self, from: data)
            print("Company info loaded successfully")
        } catch {
            print("Failed to load company info (using defaults): \(error)")
            companyInfo = CompanyInformation()
        }
    }
    
    // MARK: - Helper Methods
    func resetToDefaults() {
        companyInfo = CompanyInformation()
        saveToFile()
    }
}
