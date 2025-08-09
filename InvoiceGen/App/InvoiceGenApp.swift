//
//  InvoiceGenApp.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

@main
struct InvoiceGenApp: App {
    init() {
        FontLoader.shared.loadFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environment(\.layoutDirection, .rightToLeft)
                .environment(\.locale, Locale(identifier: "fa_IR"))
        }
    }
}
