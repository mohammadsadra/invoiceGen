# InvoiceGen - iOS App

## Project Structure

This project follows a professional iOS development architecture with clear separation of concerns and modular design.

### 📁 Directory Structure

```
InvoiceGen/
├── App/                          # App-level components
│   ├── Scenes/                   # Main app scenes
│   ├── Coordinators/             # Navigation coordinators
│   └── Delegates/                # App delegates
├── Core/                         # Core functionality
│   ├── Models/                   # Data models
│   ├── Extensions/               # Swift extensions
│   ├── Protocols/                # Protocol definitions
│   ├── Constants/                # App constants
│   └── Enums/                    # Enumerations
├── Features/                     # Feature modules
│   ├── Invoices/                 # Invoice feature
│   │   ├── Views/                # Invoice views
│   │   ├── ViewModels/           # Invoice view models
│   │   └── Models/               # Invoice models
│   ├── Customers/                # Customer feature
│   │   ├── Views/                # Customer views
│   │   ├── ViewModels/           # Customer view models
│   │   └── Models/               # Customer models
│   └── Settings/                 # Settings feature
│       ├── Views/                # Settings views
│       ├── ViewModels/           # Settings view models
│       └── Models/               # Settings models
├── Services/                     # Business logic services
│   ├── Storage/                  # Data storage services
│   ├── Networking/               # Network services
│   ├── Analytics/                # Analytics services
│   └── Notification/             # Push notification services
├── UI/                          # User interface components
│   ├── Components/               # Reusable UI components
│   │   ├── Common/               # Common components
│   │   ├── Forms/                # Form components
│   │   ├── Cards/                # Card components
│   │   └── Buttons/              # Button components
│   ├── Theme/                    # App theme and styling
│   ├── Animations/               # Custom animations
│   └── Modifiers/                # SwiftUI modifiers
├── Resources/                    # App resources
│   ├── Fonts/                    # Custom fonts
│   ├── Localization/             # Localization files
│   └── Configuration/            # Configuration files
├── Utils/                        # Utility functions
├── Config/                       # App configuration
└── Documentation/                # Project documentation
```

## 🏗️ Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel (MVVM) architecture pattern:
- **Models**: Data structures and business logic
- **Views**: SwiftUI views for user interface
- **ViewModels**: Business logic and state management

### Dependency Injection
Services are injected through protocols to ensure testability and modularity.

### Protocol-Oriented Programming
Extensive use of protocols for abstraction and testability.

## 📱 Features

### Core Features
- Invoice creation and management
- Customer management
- PDF generation
- Company settings
- Data persistence

### Technical Features
- SwiftUI for modern UI
- Core Data for local storage
- PDF generation
- Custom fonts support
- Theme system

## 🛠️ Development Guidelines

### Code Style
- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Add comprehensive documentation
- Keep functions small and focused

### File Naming
- Use PascalCase for types and protocols
- Use camelCase for variables and functions
- Add descriptive suffixes (View, ViewModel, Model, etc.)

### Organization
- Group related files together
- Use MARK comments for code sections
- Keep files under 500 lines when possible
- Separate concerns clearly

### Testing
- Write unit tests for business logic
- Use dependency injection for testability
- Mock external dependencies
- Test edge cases and error scenarios

## 🔧 Configuration

### Environment Setup
The app supports multiple environments:
- Development
- Staging
- Production

### Feature Flags
Feature flags are managed in `AppConfig.swift` to enable/disable features without code changes.

## 📦 Dependencies

### Internal Dependencies
- Core Data for persistence
- PDFKit for PDF generation
- SwiftUI for UI framework

### External Dependencies
- None currently (keeping it lightweight)

## 🚀 Getting Started

1. Clone the repository
2. Open `InvoiceGen.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project

## 📋 Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## 🤝 Contributing

1. Create a feature branch
2. Follow the coding guidelines
3. Add tests for new functionality
4. Submit a pull request

## 📄 License

This project is proprietary software.
