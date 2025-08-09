import SwiftUI

struct FloatingActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    init(
        icon: String,
        color: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(color)
                .clipShape(Circle())
                .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FloatingActionMenu: View {
    @State private var isExpanded = false
    let actions: [FloatingAction]
    
    struct FloatingAction {
        let icon: String
        let title: String
        let color: Color
        let action: () -> Void
    }
    
    init(actions: [FloatingAction]) {
        self.actions = actions
    }
    
    var body: some View {
        VStack {
            if isExpanded {
                ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
                    VStack(spacing: 8) {
                        Text(action.title)
                            .font(.vazirmatenCaption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isExpanded = false
                            }
                            action.action()
                        }) {
                            Image(systemName: action.icon)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                                .background(action.color)
                                .clipShape(Circle())
                                .shadow(color: action.color.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ProgressButton: View {
    let title: String
    let isLoading: Bool
    let isEnabled: Bool
    let color: Color
    let action: () -> Void
    
    init(
        title: String,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        color: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                Text(title)
                    .font(.vazirmatenBody)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isEnabled ? color : Color.gray)
            .cornerRadius(12)
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

#Preview {
    VStack(spacing: 30) {
        FloatingActionButton(
            icon: "plus",
            color: .blue
        ) {
            print("FAB tapped")
        }
        
        FloatingActionMenu(actions: [
            FloatingActionMenu.FloatingAction(
                icon: "person.circle",
                title: "مشتری جدید",
                color: .green
            ) {
                print("New customer")
            },
            
            FloatingActionMenu.FloatingAction(
                icon: "doc.badge.plus",
                title: "فاکتور جدید",
                color: .blue
            ) {
                print("New invoice")
            },
            
            FloatingActionMenu.FloatingAction(
                icon: "gear",
                title: "تنظیمات",
                color: .orange
            ) {
                print("Settings")
            }
        ])
        
        ProgressButton(
            title: "ذخیره فاکتور",
            isLoading: false,
            isEnabled: true
        ) {
            print("Save invoice")
        }
    }
    .padding()
}
