//
//  DockIcon.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-26.
//
import SwiftUI

struct DockIcon: View {
    
    @Environment(\.pixelLength) var pixelLength
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            let squircleSize = size * 0.8
            
            ZStack(alignment: .center) {
                VStack {
                    ForEach(0..<8) { _ in
                        Spacer()
                        Rectangle()
                            .fill(.white.gradient)
                            .opacity(1)
                            .frame(height: 1)
                        Spacer()
                    }
                }
                HStack {
                    ForEach(0..<8) { _ in
                        Spacer()
                        Rectangle()
                            .fill(.white.gradient)
                            .opacity(1)
                            .frame(width: 1)
                        Spacer()
                    }
                }
                
                
                Image(systemName: "dot.scope.display")
                    .font(.system(size: size * 0.45))
                    .foregroundColor(.white)
                    .shadow(radius: 8)
            }
            .frame(maxWidth: squircleSize, maxHeight: squircleSize)
            .background(.blue.gradient)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.18, style: .continuous))
            .padding(size * 0.10)
        }
    }
}

#Preview  {
    VStack {
        DockIcon()
            .frame(width: 256, height: 256)
        Image(nsImage: DockIcon().asImage(pixelWidth: 512, pixelHeight: 512))
        Button(action: {
            ImageSaver.writeImage(image: DockIcon().asSquareImage(at: 2048))
            ImageSaver.writeImage(image: DockIcon().asSquareImage(at: 1024))
            ImageSaver.writeImage(image: DockIcon().asSquareImage(at: 512))
            ImageSaver.writeImage(image: DockIcon().asSquareImage(at: 256))
            ImageSaver.writeImage(image: DockIcon().asSquareImage(at: 128))
            ImageSaver.writeImage(image: DockIcon().asSquareImage(at: 64))
            ImageSaver.writeImage(image: DockIcon().asSquareImage(at: 32))
        }) {
            Text("Save")
        }
    }
    .padding()
}
