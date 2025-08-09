import SwiftUI

extension View {
    
    // MARK: - Common Modifiers
    
    /// Applies the app's standard corner radius
    func standardCornerRadius() -> some View {
        self.cornerRadius(AppTheme.CornerRadius.large)
    }
    
    /// Applies the app's standard padding
    func standardPadding() -> some View {
        self.padding(AppTheme.Spacing.md)
    }
    
    /// Applies the app's standard background
    func standardBackground() -> some View {
        self.background(AppTheme.Colors.surface)
    }
    
    /// Applies the app's standard shadow
    func standardShadow() -> some View {
        self.shadow(
            color: AppTheme.Shadows.medium.color,
            radius: AppTheme.Shadows.medium.radius,
            x: AppTheme.Shadows.medium.x,
            y: AppTheme.Shadows.medium.y
        )
    }
    
    // MARK: - Layout Modifiers
    
    /// Centers the view horizontally
    func centerHorizontally() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    /// Centers the view vertically
    func centerVertically() -> some View {
        self.frame(maxHeight: .infinity, alignment: .center)
    }
    
    /// Makes the view fill available space
    func fillSpace() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Conditional Modifiers
    
    /// Conditionally applies a modifier
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Conditionally applies a modifier with an else case
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    // MARK: - Animation Modifiers
    
    /// Applies a smooth animation for state changes
    func smoothAnimation() -> some View {
        self.animation(.easeInOut(duration: 0.3), value: true)
    }
    
    /// Applies a spring animation for interactive elements
    func springAnimation() -> some View {
        self.animation(.spring(response: 0.3, dampingFraction: 0.7), value: true)
    }
    
    // MARK: - Accessibility Modifiers
    
    /// Adds accessibility label and hint
    func accessible(_ label: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(label)
            .if(hint != nil) { view in
                view.accessibilityHint(hint!)
            }
    }
    
    // MARK: - Debug Modifiers
    
    #if DEBUG
    /// Adds a debug border (only in debug builds)
    func debugBorder(_ color: Color = .red) -> some View {
        self.border(color, width: 1)
    }
    #endif
}

// MARK: - Color Extensions

extension Color {
    /// Creates a color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
