import SwiftUI

struct AppTheme {
    
    // MARK: - Colors
    struct Colors {
        static let primary = Color("PrimaryColor")
        static let secondary = Color("SecondaryColor")
        static let accent = Color("AccentColor")
        static let background = Color("BackgroundColor")
        static let surface = Color("SurfaceColor")
        static let text = Color("TextColor")
        static let textSecondary = Color("TextSecondaryColor")
        static let error = Color("ErrorColor")
        static let success = Color("SuccessColor")
        static let warning = Color("WarningColor")
        static let border = Color("BorderColor")
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.custom("Vazirmatn-Bold", size: 34)
        static let title1 = Font.custom("Vazirmatn-Bold", size: 28)
        static let title2 = Font.custom("Vazirmatn-Bold", size: 22)
        static let title3 = Font.custom("Vazirmatn-Bold", size: 20)
        static let headline = Font.custom("Vazirmatn-Medium", size: 17)
        static let body = Font.custom("Vazirmatn-Regular", size: 17)
        static let callout = Font.custom("Vazirmatn-Regular", size: 16)
        static let subheadline = Font.custom("Vazirmatn-Regular", size: 15)
        static let footnote = Font.custom("Vazirmatn-Regular", size: 13)
        static let caption = Font.custom("Vazirmatn-Regular", size: 12)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
        static let xl: CGFloat = 16
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        static let large = Shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
