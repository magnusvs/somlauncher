//
//  SectionStyles.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-06.
//
import SwiftUI

extension View {
    func sectionStyle() -> some View {
        self
            .background(Color(NSColor.windowBackgroundColor.withAlphaComponent(0.1)))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(NSColor.separatorColor), lineWidth: 1) // Add border with corner radius
            )
    }
}
