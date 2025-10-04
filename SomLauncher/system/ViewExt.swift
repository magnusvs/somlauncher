//
//  ViewExt.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-27.
//
import SwiftUI

public extension View {
    
    @MainActor func asSquareImage(at size: CGFloat) -> NSImage {
        return asImage(pixelWidth: size, pixelHeight: size)
    }
    
    @MainActor func asImage(pixelWidth: CGFloat, pixelHeight: CGFloat) -> NSImage {
        let screenScale = NSView().convertToBacking(NSSize(width: 1.0, height: 1.0)).width
        let width = pixelWidth / screenScale
        let height = pixelHeight / screenScale
        
        let framedView = self.frame(width: width, height: height)
        let cgImage = ImageRenderer(content: framedView).cgImage!

        return NSImage(cgImage: cgImage, size: .init(width: width, height: height))
    }
    
    
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
    
    // Conditionally apply a transform without duplicating view branches
    @ViewBuilder func `if`(_ condition: Bool, @ViewBuilder transform: (Self) -> some View) -> some View {
        if condition { transform(self) } else { self }
    }
}
