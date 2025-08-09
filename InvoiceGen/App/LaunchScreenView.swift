//
//  LaunchScreenView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var showMainApp = false
    
    var body: some View {
        if showMainApp {
            ContentView()
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // NOVA Logo
                    Image("NovaLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 80)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                    
                    // App Title
                    Text("فاکتور ساز")
                        .font(.vazirmatenTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("تولید آسان فاکتور PDF")
                        .font(.vazirmatenHeadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .onAppear {
                isAnimating = true
                
                // Show main app after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showMainApp = true
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
