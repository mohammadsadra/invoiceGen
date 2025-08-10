//
//  SettingsComponents.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI

// MARK: - Settings Row Component

struct SettingsRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
                .font(.system(size: 16, weight: .medium))
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Chevron for navigation/action items
            if action != nil {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .medium))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
}

// MARK: - Settings Info Row Component

struct SettingsInfoRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
                .font(.system(size: 16, weight: .medium))
            
            // Title
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Value
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Company Settings Components

struct CompanyTextFieldRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
                .font(.system(size: 16, weight: .medium))
            
            // Text Field
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct CompanyActionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
                .font(.system(size: 16, weight: .medium))
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Chevron for action items
            if action != nil {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .medium))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action?()
        }
    }
}
