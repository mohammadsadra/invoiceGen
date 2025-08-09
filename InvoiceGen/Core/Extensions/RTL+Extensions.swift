import SwiftUI

// MARK: - RTL Layout Extensions
extension View {
    /// Applies RTL environment to the view
    func rtlEnvironment() -> some View {
        self.environment(\.layoutDirection, .rightToLeft)
    }
    
    /// Applies RTL layout with flip for images
    func rtlLayoutWithFlip() -> some View {
        self.scaleEffect(x: -1, y: 1, anchor: .center)
    }
    
    /// Centers content horizontally in RTL layout
    func centerHorizontallyRTL() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    /// Aligns content to the right in RTL layout
    func alignRightRTL() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    /// Aligns content to the left in RTL layout
    func alignLeftRTL() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// RTL-aware padding
    func rtlPadding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        self.padding(edges, length)
    }
    
    /// RTL horizontal padding
    func rtlHorizontalPadding(_ length: CGFloat? = nil) -> some View {
        self.padding(.horizontal, length)
    }
    
    /// RTL vertical padding
    func rtlVerticalPadding(_ length: CGFloat? = nil) -> some View {
        self.padding(.vertical, length)
    }
    
    /// RTL corner radius
    func rtlCornerRadius(_ radius: CGFloat) -> some View {
        self.cornerRadius(radius)
    }
    
    /// RTL shadow
    func rtlShadow(color: Color = .black, radius: CGFloat = 10, x: CGFloat = 0, y: CGFloat = 5) -> some View {
        self.shadow(color: color, radius: radius, x: x, y: y)
    }
}

// MARK: - RTL Text Alignment Extensions
extension TextAlignment {
    static var rtlLeading: TextAlignment { .leading }
    static var rtlTrailing: TextAlignment { .trailing }
}

// MARK: - RTL Color Extensions
extension Color {
    static var rtlAccent: Color { .blue }
    static var rtlPrimary: Color { .primary }
    static var rtlSecondary: Color { .secondary }
}

// MARK: - RTL Font Extensions
extension Font {
    static var rtlBody: Font { .body }
    static var rtlHeadline: Font { .headline }
    static var rtlTitle: Font { .title }
    static var rtlCaption: Font { .caption }
}

// MARK: - RTL Spacer Extensions
extension Spacer {
    /// Creates a spacer with RTL-aware behavior
    static func rtl() -> Spacer {
        return Spacer()
    }
}

// MARK: - RTL Image Extensions
extension Image {
    /// Creates an image with RTL-aware scaling
    func rtlScale() -> some View {
        self.scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
