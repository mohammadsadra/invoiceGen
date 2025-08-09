import SwiftUI

struct CommonButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    let isEnabled: Bool
    
    init(
        _ title: String,
        style: ButtonStyle = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.headline)
                .foregroundColor(style.textColor)
                .frame(maxWidth: .infinity)
                .frame(height: AppConstants.UI.buttonHeight)
                .background(style.backgroundColor)
                .cornerRadius(AppTheme.CornerRadius.large)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(style.borderColor, lineWidth: 1)
                )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

enum ButtonStyle {
    case primary
    case secondary
    case destructive
    case outline
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return AppTheme.Colors.primary
        case .secondary:
            return AppTheme.Colors.secondary
        case .destructive:
            return AppTheme.Colors.error
        case .outline:
            return Color.clear
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary, .secondary, .destructive:
            return .white
        case .outline:
            return AppTheme.Colors.primary
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary, .secondary, .destructive:
            return Color.clear
        case .outline:
            return AppTheme.Colors.primary
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CommonButton("Primary Button") {
            print("Primary tapped")
        }
        
        CommonButton("Secondary Button", style: .secondary) {
            print("Secondary tapped")
        }
        
        CommonButton("Destructive Button", style: .destructive) {
            print("Destructive tapped")
        }
        
        CommonButton("Outline Button", style: .outline) {
            print("Outline tapped")
        }
        
        CommonButton("Disabled Button", isEnabled: false) {
            print("Disabled tapped")
        }
    }
    .padding()
}
