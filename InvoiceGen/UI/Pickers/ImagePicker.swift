//
//  ImagePicker.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    let sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        
        // Check if source type is available
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            print("Source type \(sourceType.rawValue) is not available")
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("Image picker did finish picking media")
            
            if let editedImage = info[.editedImage] as? UIImage {
                print("Using edited image")
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                print("Using original image")
                parent.selectedImage = originalImage
            } else {
                print("No image found in picker result")
            }
            
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// Modern Photo Picker for iOS 14+
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print("PhotoPicker did finish picking, results count: \(results.count)")
            parent.dismiss()
            
            guard let provider = results.first?.itemProvider else { 
                print("No item provider found")
                return 
            }
            
            print("Item provider can load UIImage: \(provider.canLoadObject(ofClass: UIImage.self))")
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error loading image: \(error)")
                        } else if let image = image as? UIImage {
                            print("Successfully loaded image from PhotoPicker")
                            self.parent.selectedImage = image
                        } else {
                            print("Could not cast loaded object to UIImage")
                        }
                    }
                }
            }
        }
    }
}
