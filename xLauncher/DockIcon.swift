//
//  DockIcon.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-26.
//
import SwiftUI

struct DockIcon: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "dot.scope.laptopcomputer")
                .font(.system(size: 48))
                .foregroundColor(.white)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .padding(12)
    }
}

#Preview  {
    VStack {
        DockIcon()
    }
    .frame(width: 120, height: 120)
    .padding()
}
