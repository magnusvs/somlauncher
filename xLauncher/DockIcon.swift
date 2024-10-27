//
//  DockIcon.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-26.
//
import SwiftUI

struct DockIcon: View {
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            VStack(alignment: .center) {
                Image(systemName: "dot.scope.laptopcomputer")
                    .font(.system(size: size / 2))
                    .foregroundColor(.white)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    }
    .padding()
}
