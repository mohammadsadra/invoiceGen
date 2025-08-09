import SwiftUI

struct FormTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let textAlignment: TextAlignment
    let isRequired: Bool
    
    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        textAlignment: TextAlignment = .trailing,
        isRequired: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.textAlignment = textAlignment
        self.isRequired = isRequired
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                Text(title)
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .font(.vazirmatenBody)
                }
                
                Spacer()
            }
            
            TextField(placeholder, text: $text)
                .font(.vazirmatenBody)
                .keyboardType(keyboardType)
                .multilineTextAlignment(textAlignment)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isRequired && text.isEmpty ? Color.red.opacity(0.5) : Color.clear, lineWidth: 1)
                )
        }
    }
}

struct FormNumberField: View {
    let title: String
    let placeholder: String
    @Binding var value: Double
    let isRequired: Bool
    
    init(
        title: String,
        placeholder: String,
        value: Binding<Double>,
        isRequired: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._value = value
        self.isRequired = isRequired
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                Text(title)
                    .font(.vazirmatenBody)
                    .fontWeight(.medium)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                        .font(.vazirmatenBody)
                }
                
                Spacer()
            }
            
            TextField(placeholder, value: $value, format: .number)
                .font(.vazirmatenBody)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isRequired && value == 0 ? Color.red.opacity(0.5) : Color.clear, lineWidth: 1)
                )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        FormTextField(
            title: "نام مشتری",
            placeholder: "نام مشتری را وارد کنید",
            text: .constant(""),
            isRequired: true
        )
        
        FormTextField(
            title: "ایمیل",
            placeholder: "example@email.com",
            text: .constant(""),
            keyboardType: .emailAddress
        )
        
        FormNumberField(
            title: "قیمت",
            placeholder: "0",
            value: .constant(0.0)
        )
    }
    .padding()
}
