//
//  ViewExt.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-27.
//
import SwiftUI

public extension View {
    
    @MainActor func asImage(pixelWidth: CGFloat, pixelHeight: CGFloat) -> NSImage {
        let screenScale = NSView().convertToBacking(NSSize(width: 1.0, height: 1.0)).width
        let width = pixelWidth / screenScale
        let height = pixelHeight / screenScale
        
        let framedView = self.frame(width: width, height: height)
        let cgImage = ImageRenderer(content: framedView).cgImage!

        return NSImage(cgImage: cgImage, size: .init(width: width, height: height))
    }
}
