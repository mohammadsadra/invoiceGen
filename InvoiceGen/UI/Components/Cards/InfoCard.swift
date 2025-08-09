import SwiftUI

struct InfoCard<Content: View>: View {
    let title: String?
    let icon: String?
    let color: Color
    let content: Content
    
    init(
        title: String? = nil,
        icon: String? = nil,
        color: Color = .blue,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            if let title = title {
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                            .foregroundColor(color)
                            .font(.title3)
                    }
                    
                    Text(title)
                        .font(.vazirmatenHeadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
            }
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let color: Color
    let icon: String?
    
    init(
        title: String,
        value: String,
        subtitle: String? = nil,
        color: Color = .blue,
        icon: String? = nil
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
        self.icon = icon
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title2)
                }
                
                Text(title)
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(value)
                .font(.vazirmatenHeadline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.vazirmatenCaption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ActionCard: View {
    let title: String
    let subtitle: String?
    let icon: String
    let color: Color
    let action: () -> Void
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        color: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(title)
                        .font(.vazirmatenBody)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        InfoCard(
            title: "اطلاعات مشتری",
            icon: "person.circle",
            color: .green
        ) {
            VStack(alignment: .trailing, spacing: 8) {
                Text("احمد محمدی")
                    .font(.vazirmatenBody)
                    .fontWeight(.semibold)
                
                Text("09123456789")
                    .font(.vazirmatenBody)
                    .foregroundColor(.secondary)
                
                Text("ahmad@example.com")
                    .font(.vazirmatenBody)
                    .foregroundColor(.secondary)
            }
        }
        
        SummaryCard(
            title: "مبلغ کل",
            value: "۲,۵۰۰,۰۰۰ تومان",
            subtitle: "شامل مالیات",
            color: .blue,
            icon: "creditcard"
        )
        
        ActionCard(
            title: "انتخاب مشتری",
            subtitle: "مشتری جدید یا موجود",
            icon: "person.circle",
            color: .blue
        ) {
            print("Customer selection tapped")
        }
    }
    .padding()
}
