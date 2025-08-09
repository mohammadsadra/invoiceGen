//
//  SignatureDrawingView.swift
//  InvoiceGen
//
//  Created by mohammadsadra on 8/7/25.
//

import SwiftUI
import PencilKit

struct SignatureDrawingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var canvasView = PKCanvasView()
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
                
                SignatureCanvasView(canvasView: $canvasView, hasDrawn: $hasDrawn)
                    .frame(height: 200)
                    .border(Color.gray.opacity(0.5), width: 2)
                    .padding()
                    .background(Color.white)
                
                HStack(spacing: 20) {
                    Button("پاک کردن") {
                        print("Clear button tapped")
                        canvasView.drawing = PKDrawing()
                        hasDrawn = false
                        print("Canvas cleared, hasDrawn set to false")
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
        let image = canvasView.drawing.image(from: canvasView.bounds, scale: 2.0)
        
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

struct SignatureCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var hasDrawn: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        print("Creating PKCanvasView for signature drawing")
        
        // Create a fresh canvas view instead of using the binding
        let canvas = PKCanvasView()
        
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: .black, width: 3)
        canvas.backgroundColor = UIColor.white
        canvas.isOpaque = true
        canvas.alwaysBounceVertical = false
        canvas.alwaysBounceHorizontal = false
        canvas.showsVerticalScrollIndicator = false
        canvas.showsHorizontalScrollIndicator = false
        
        // Enable drawing
        canvas.isUserInteractionEnabled = true
        canvas.delegate = context.coordinator
        
        // Force enable multi-touch and drawing
        canvas.isMultipleTouchEnabled = true
        canvas.maximumZoomScale = 1.0
        canvas.minimumZoomScale = 1.0
        canvas.zoomScale = 1.0
        
        // Update the binding to reference this canvas
        DispatchQueue.main.async {
            self.canvasView = canvas
        }
        
        print("PKCanvasView configured: userInteractionEnabled=\(canvas.isUserInteractionEnabled)")
        print("PKCanvasView tool: \(canvas.tool)")
        print("PKCanvasView drawing policy: \(canvas.drawingPolicy.rawValue)")
        
        // Become first responder after a delay to ensure view is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            canvas.becomeFirstResponder()
            print("PKCanvasView became first responder: \(canvas.isFirstResponder)")
        }
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Always ensure tool is set correctly (PKTool comparison is not straightforward)
        uiView.tool = PKInkingTool(.pen, color: .black, width: 3)
        
        // Ensure drawing policy is correct
        if uiView.drawingPolicy != .anyInput {
            uiView.drawingPolicy = .anyInput
            print("Drawing policy updated to anyInput")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        let parent: SignatureCanvasView
        
        init(_ parent: SignatureCanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            print("Canvas drawing did change - strokes count: \(canvasView.drawing.strokes.count)")
            let hasStrokes = !canvasView.drawing.strokes.isEmpty
            parent.hasDrawn = hasStrokes
            print("hasDrawn updated to: \(hasStrokes)")
        }
        
        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            print("Canvas did begin using tool")
        }
        
        func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            print("Canvas did end using tool")
        }
    }
}

#Preview {
    SignatureDrawingView { _ in }
}
