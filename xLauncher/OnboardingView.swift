//
//  OnboardingView.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-11-23.
//
import SwiftUI

struct OnboardingView: View {
    
    @State var isVisible = false
    
    var body: some View {
        VStack() {
            if (isVisible) {
                VStack {
                    DockIcon()
                        .frame(width: 128, height: 128)
                    Text("xLauncher")
                        .font(.largeTitle)
                    
                    Spacer()
                }
            
                .transition(.offset(x: 0, y: 48).combined(with: .opacity))
            }
        }
        .onAppear {
            withAnimation(.default) {
                isVisible = true
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

#Preview {
    OnboardingView()
}
