//
//  ButtonStyles.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-06.
//
import SwiftUI

struct NavigationLinkButtonStyle: ButtonStyle {
    var showChevron: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()

            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(configuration.isPressed ? Color(NSColor.separatorColor) : Color.clear)
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
