//
//  ImageStorageManager.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
//

import UIKit
import SwiftUI

class ImageStorageManager: ObservableObject {
    static let shared = ImageStorageManager()
    
    @Published var companyLogo: UIImage?
    @Published var signature: UIImage?
    
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    private var logoURL: URL {
        return documentsPath.appendingPathComponent("company_logo.png")
    }
    
    private var signatureURL: URL {
        return documentsPath.appendingPathComponent("signature.png")
    }
    
    private init() {
        loadImages()
    }
    
    // MARK: - Company Logo
    func saveCompanyLogo(_ image: UIImage) {
        print("saveCompanyLogo called with image size: \(image.size)")
        guard let data = image.pngData() else {
            print("Failed to convert logo to PNG data")
            return
        }
        
        print("PNG data size: \(data.count) bytes")
        print("Saving to: \(logoURL.path)")
        
        do {
            try data.write(to: logoURL)
            DispatchQueue.main.async {
                self.companyLogo = image
                print("Company logo updated in @Published property")
            }
            print("Company logo saved successfully")
        } catch {
            print("Failed to save company logo: \(error)")
        }
    }
    
    func deleteCompanyLogo() {
        do {
            try FileManager.default.removeItem(at: logoURL)
            DispatchQueue.main.async {
                self.companyLogo = nil
            }
            print("Company logo deleted successfully")
        } catch {
            print("Failed to delete company logo: \(error)")
        }
    }
    
    // MARK: - Signature
    func saveSignature(_ image: UIImage) {
        guard let data = image.pngData() else {
            print("Failed to convert signature to PNG data")
            return
        }
        
        do {
            try data.write(to: signatureURL)
            DispatchQueue.main.async {
                self.signature = image
            }
            print("Signature saved successfully")
        } catch {
            print("Failed to save signature: \(error)")
        }
    }
    
    func deleteSignature() {
        do {
            try FileManager.default.removeItem(at: signatureURL)
            DispatchQueue.main.async {
                self.signature = nil
            }
            print("Signature deleted successfully")
        } catch {
            print("Failed to delete signature: \(error)")
        }
    }
    
    // MARK: - Private Methods
    private func loadImages() {
        // Load company logo
        if FileManager.default.fileExists(atPath: logoURL.path) {
            if let data = try? Data(contentsOf: logoURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.companyLogo = image
                }
            }
        }
        
        // Load signature
        if FileManager.default.fileExists(atPath: signatureURL.path) {
            if let data = try? Data(contentsOf: signatureURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.signature = image
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    func resizeImage(_ image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
        let size = image.size
        let widthRatio = maxWidth / size.width
        let heightRatio = maxHeight / size.height
        let ratio = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
}
