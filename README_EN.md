# InvoiceGen - Persian Invoice Generator

A modern iOS application for creating and managing invoices in Persian/Farsi language with PDF generation capabilities.

## 🌟 Features

### 📝 Invoice Management
- ✅ Complete invoice form with all necessary fields
- ✅ Customer information management (name, email, phone, address)
- ✅ Multiple items/services support
- ✅ Automatic tax and total calculations
- ✅ Invoice preview before PDF generation
- ✅ PDF generation with sharing capabilities

### 💾 Storage & Management
- ✅ **Local invoice storage**
- ✅ **Edit saved invoices**
- ✅ **View saved invoices list**
- ✅ **Search invoices** (by number, customer name, notes)
- ✅ **Sort invoices** (date, number, customer name, amount)
- ✅ **Copy and duplicate invoices**
- ✅ **Delete unnecessary invoices**
- ✅ **Overall statistics** (total invoices, total revenue, current month invoices)

### 🎨 Design & Display
- ✅ Persian/Farsi UI with RTL (Right-to-Left) support
- ✅ Vazirmatn font for beautiful Persian text display
- ✅ Persian calendar for invoice dates
- ✅ Persian numbers in amounts and dates
- ✅ Modern and user-friendly design
- ✅ **Complete invoice details view**
- ✅ **Easy navigation between invoices**
- ✅ **Company logo upload and display**
- ✅ **Digital signature drawing and upload**
- ✅ **Company settings customization**
- ✅ **Edit company information** (name, address, phone, email)
- ✅ **Automatic company settings save**

## 🚀 How to Use

### Creating a New Invoice
1. **Enter invoice information**: Invoice number, issue date, and due date
2. **Customer information**: Complete customer name, email, phone, and address
3. **Add items**: Enter item/service description, quantity, and unit price
4. **Financial settings**: Enter tax percentage if needed
5. **Notes**: Write additional notes for the invoice
6. **Save**: Click the "Save" button
7. **Preview**: Click the "Preview" button
8. **Generate PDF**: In the preview page, click "Generate PDF"

### Managing Saved Invoices
1. **View invoices**: Go to the "Saved Invoices" tab
2. **Search**: Use the search bar to find specific invoices
3. **Sort**: Click the sort icon
4. **View details**: Click on any invoice
5. **Edit**: In the details page, click "Edit"
6. **Copy invoice**: Click "Copy" to create a new invoice with the same information
7. **Delete**: Click "Delete" to remove the invoice

### Company Settings & Customization
1. **Access settings**: Go to the "Company Settings" tab
2. **Edit company information**: Enter name, address, city, phone, email, and website
3. **Upload logo**: Click "Upload Logo" and select from gallery or camera
4. **Draw signature**: Click "Draw Signature" and draw your signature with finger or pen
5. **Upload signature**: Click "Upload Signature" to select signature image from gallery
6. **Delete images**: If needed, click "Delete" to remove logo or signature
7. **Auto-save**: All changes are automatically saved

## 🏗️ Project Structure

```
InvoiceGen/
├── App/
│   ├── ContentView.swift           # Main content view
│   ├── InvoiceGenApp.swift         # App entry point
│   ├── LaunchScreenView.swift      # Launch screen
│   └── MainTabView.swift           # Main tab navigation
├── Core/
│   ├── Constants/
│   │   └── AppConstants.swift      # App constants
│   ├── Enums/
│   │   └── InvoiceStatus.swift     # Invoice status enum
│   ├── Extensions/
│   │   ├── RTL+Extensions.swift    # RTL layout extensions
│   │   └── View+Extensions.swift   # View extensions
│   ├── Models/
│   │   └── Models.swift            # Data models (Invoice, Customer, Items)
│   ├── Protocols/
│   │   └── StorageProtocol.swift   # Storage protocols
│   └── Utilities/
│       └── Utilities.swift         # Utility functions
├── Features/
│   ├── Customers/
│   │   ├── CustomerEditView.swift  # Customer editing
│   │   ├── CustomerListView.swift  # Customer list
│   │   └── CustomerSelectionView.swift
│   ├── Invoices/
│   │   ├── InvoiceDetailView.swift # Invoice details
│   │   ├── InvoiceFormView.swift   # Invoice form
│   │   ├── InvoicePreviewView.swift # Invoice preview
│   │   ├── PDFGenerator.swift      # PDF generation
│   │   └── SavedInvoicesView.swift # Saved invoices
│   └── Settings/
│       └── CompanySettingsView.swift # Company settings
├── Services/
│   ├── CompanyInfoManager.swift    # Company info management
│   ├── ImageStorageManager.swift   # Image storage
│   └── Storage/
│       └── InvoiceStorageManager.swift # Invoice storage
└── UI/
    ├── Components/
    │   ├── Buttons/
    │   ├── Cards/
    │   ├── Forms/
    │   └── Common/
    ├── Theme/
    │   └── AppTheme.swift          # App theme
    └── Utils/
        └── FontLoader.swift        # Font loading
```

## 📋 Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+

## 🛠️ Installation & Setup

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/InvoiceGen.git
   ```

2. Open the project in Xcode
   ```bash
   cd InvoiceGen
   open InvoiceGen.xcodeproj
   ```

3. Select an iOS device or simulator

4. Build and run the project (⌘+R)

## 🎯 Key Features

### Persian Language Support
- Full RTL (Right-to-Left) layout support
- Persian calendar integration
- Persian number formatting
- Vazirmatn font for beautiful Persian text

### Invoice Management
- Create, edit, and delete invoices
- Customer management
- Multiple items per invoice
- Automatic calculations (subtotal, tax, total)
- PDF generation and sharing

### Company Customization
- Company logo upload
- Digital signature support
- Company information management
- Professional invoice templates

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Vazirmatn font for Persian text support
- SwiftUI for modern UI development
- PDFKit for PDF generation capabilities

## 📞 Support

If you have any questions or need support, please open an issue on GitHub.

---

**Made with ❤️ for the Persian community**
