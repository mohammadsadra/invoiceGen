//
//  FontLoader.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import UIKit
import CoreText

class FontLoader {
    static let shared = FontLoader()
    
    private init() {}
    
    func loadFonts() {
        // Load fonts asynchronously to avoid blocking the main thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadFont(named: "Vazirmatn-Regular")
            self.loadFont(named: "Vazirmatn-Medium")
            self.loadFont(named: "Vazirmatn-Bold")
        }
    }
    
    private func loadFont(named fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
            print("Could not find font file: \(fontName).ttf")
            return
        }
        
        guard let fontData = NSData(contentsOf: fontURL) else {
            print("Could not load font data from: \(fontURL)")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("Could not create data provider for font: \(fontName)")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("Could not create font from data provider: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            if let error = error {
                let errorDescription = CFErrorCopyDescription(error.takeUnretainedValue())
                print("Failed to register font \(fontName): \(String(describing: errorDescription))")
            }
        } else {
            print("Successfully registered font: \(fontName)")
        }
    }
}
