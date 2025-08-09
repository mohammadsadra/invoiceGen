//
//  SimpleSignatureView.swift
//  InvoiceGen
//
//  Created by Masan on 8/7/25.
//

import SwiftUI
import PencilKit

struct SimpleSignatureView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var drawing = PKDrawing()
    @State private var hasDrawn = false
    
    let onSave: (UIImage) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 8) {
                    Text("امضای خود را در کادر زیر بکشید")
                        .font(.vazirmatenBody)
                    
                    Text("از انگشت یا قلم برای کشیدن امضا استفاده کنید")
                        .font(.vazirmatenCaption)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                SimpleCanvasView(drawing: $drawing, hasDrawn: $hasDrawn)
                    .frame(height: 200)
                    .border(Color.gray.opacity(0.5), width: 2)
                    .padding()
                    .background(Color.white)
                
                HStack(spacing: 20) {
                    Button("پاک کردن") {
                        print("Clear button tapped - Simple version")
                        drawing = PKDrawing()
                        hasDrawn = false
                        print("Drawing cleared, hasDrawn set to false")
                    }
                    .font(.vazirmatenBody)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    Button("ذخیره امضا") {
                        saveSignature()
                    }
                    .font(.vazirmatenBody)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!hasDrawn)
                }
                .padding()
            }
            .navigationTitle("رسم امضا")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("انصراف") {
                        dismiss()
                    }
                    .font(.vazirmatenBody)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    private func saveSignature() {
        let bounds = CGRect(x: 0, y: 0, width: 400, height: 200)
        let image = drawing.image(from: bounds, scale: 2.0)
        
        // Create a white background image
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let finalImage = renderer.image { context in
            // Fill with white background
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: image.size))
            
            // Draw the signature on top
            image.draw(at: .zero)
        }
        
        onSave(finalImage)
        dismiss()
    }
}

struct SimpleCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var hasDrawn: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        print("Creating Simple PKCanvasView")
        
        let canvasView = PKCanvasView()
        
        // Basic configuration
        canvasView.drawing = drawing
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 3)
        canvasView.backgroundColor = UIColor.white
        canvasView.isOpaque = true
        
        // Disable scrolling
        canvasView.alwaysBounceVertical = false
        canvasView.alwaysBounceHorizontal = false
        canvasView.showsVerticalScrollIndicator = false
        canvasView.showsHorizontalScrollIndicator = false
        canvasView.maximumZoomScale = 1.0
        canvasView.minimumZoomScale = 1.0
        canvasView.zoomScale = 1.0
        
        // Enable interaction
        canvasView.isUserInteractionEnabled = true
        canvasView.isMultipleTouchEnabled = true
        canvasView.delegate = context.coordinator
        
        print("Simple PKCanvasView configured successfully")
        print("User interaction enabled: \(canvasView.isUserInteractionEnabled)")
        print("Drawing policy: \(canvasView.drawingPolicy.rawValue)")
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Update drawing if it changed externally (like clearing)
        if uiView.drawing != drawing {
            uiView.drawing = drawing
            print("Drawing updated in canvas")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        let parent: SimpleCanvasView
        
        init(_ parent: SimpleCanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            print("Simple canvas drawing changed - strokes: \(canvasView.drawing.strokes.count)")
            parent.drawing = canvasView.drawing
            parent.hasDrawn = !canvasView.drawing.strokes.isEmpty
            print("hasDrawn updated to: \(parent.hasDrawn)")
        }
        
        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            print("Simple canvas began using tool")
        }
        
        func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            print("Simple canvas ended using tool")
        }
    }
}

#Preview {
    SimpleSignatureView { _ in }
}
