//
//  OnboardingView.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-11-23.
//
import SwiftUI
import LaunchAtLogin
import SymbolPicker

struct OnboardingView: View {
    
    @State var isWelcomeVisible = false
    @State var isSettingsVisible = false
    
    var body: some View {
        VStack() {
            Spacer()
            if (isWelcomeVisible) {
                WelcomeView(onStart: {
                    withAnimation {
                        isSettingsVisible = true
                        isWelcomeVisible = false
                    }
                })
                    .transition(.offset(x: 0, y: 48).combined(with: .opacity))
            }
            if (isSettingsVisible) {
                StartSettingsView(onContinue: {})
                    .transition(.offset(x: 0, y: 48).combined(with: .opacity))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .edgesIgnoringSafeArea(.top)
        // TODO add gradient and possibly animate a wave
//        .apply {
//        extension View {
//            func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
//        }
//            if #available(macOS 15.0, *) {
//                $0.background(
//                    MeshGradient(
//                        width: 3,
//                        height: 3,
//                        points: [
//                            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
//                            [0.0, 0.5], [0.9, 0.8], [1.0, 0.5],
//                            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
//                        ],
//                        colors: [
//                            .black, .black, .black,
//                            .blue, .blue, .blue,
//                            .gray.opacity(0.5), .gray.opacity(0.5), .blue.opacity(0.5)
//                        ]
//                    )
//                )
//            } else {
//                $0.background(Color.red)
//            }
//        }
        .onAppear {
            withAnimation(.default) {
                isWelcomeVisible = true
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct StartSettingsView: View {
    @State private var iconPickerPresented = false
    @AppStorage("menu-bar-icon") var menuBarIcon: String = "dot.scope.display"
    @AppStorage("show-dock-icon") var showDockIcon: Bool = false
    
    var onContinue: () -> Void

    var launchAtLoginToggle: some View {
        VStack(alignment: .leading) {
            Text("Start xLauncher when macOS starts")
            LaunchAtLogin.Toggle() {
                HStack {
                    Text("Launch at login")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                    
                }
            }
            .toggleStyle(.checkbox)
        }.padding(.vertical, 8)
    }
    
    var menuBarIconPicker: some View {
        VStack(alignment: .leading) {
            Text("Pick a menu bar icon")
            Button {
                iconPickerPresented = true
            } label: {
                Image(systemName: menuBarIcon)
                
                Text("Menu bar icon")
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
            }
            .sheet(isPresented: $iconPickerPresented) {
                SymbolPicker(symbol: $menuBarIcon)
            }
            .buttonStyle(.plain)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("xLauncher options")
                .font(.title)
            
            launchAtLoginToggle
            
            menuBarIconPicker
                .padding(.top, 16)
            
            HStack {
                Button(action: onContinue) {
                    Text("Continue")
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 32)
            }
            Text("Options can be changed later in settings")
                .font(.caption)
                .padding(.top, 4)
        }
    }
}

struct WelcomeView: View {
    
    var onStart: () -> Void
    
    var body: some View {
        VStack {
            DockIcon()
                .frame(width: 128, height: 128)
            Text("Welcome")
                .font(.title)
            
            Button(action: onStart) {
                Text("Start")
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

#Preview {
    StartSettingsView(onContinue: {})
}


#Preview {
    OnboardingView()
}
