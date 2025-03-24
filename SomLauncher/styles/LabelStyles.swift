//
//  LabelStyles.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-07.
//
import SwiftUI

struct ReversedLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 8) {
            configuration.title
            configuration.icon
        }
    }
}
