//
//  InvoiceGenApp.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
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
        }
    }
}
