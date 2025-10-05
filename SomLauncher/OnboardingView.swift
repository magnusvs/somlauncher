//
//  OnboardingView.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-11-23.
//
import SwiftUI
import LaunchAtLogin
import SymbolPicker

struct OnboardingView: View {
    
    @State var isWelcomeVisible = false
    @State var isSettingsVisible = false
    @State var isInfoVisible = false
    
    var onOnboardingComplete: () -> Void
    
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
                StartSettingsView(onContinue: {
                    withAnimation {
                        isInfoVisible = true
                        isSettingsVisible = false
                    }
                })
                .transition(.offset(x: 0, y: 48).combined(with: .opacity))
            }
            if (isInfoVisible) {
                InfoView(onContinue: onOnboardingComplete)
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
    
    private var launchAtLoginToggle: some View {
        VStack(alignment: .leading) {
            Text("Start SomLauncher when macOS starts")
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
    
    private var menuBarIconPicker: some View {
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
            Text("SomLauncher options")
                .font(.title)
            
            launchAtLoginToggle
            
            menuBarIconPicker
                .padding(.top, 16)
            
            GradientButton(action: onContinue, text: "Continue")
                .padding(.top, 32)
            Text("Options can be changed later in settings")
                .font(.caption)
                .padding(.top, 4)
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct InfoView: View {
    
    @AppStorage("menu-bar-icon") var menuBarIcon: String = "dot.scope.display"
    
    private let selectedApp: InstalledApp? = FileManager.default.getAppByUrl(url: URL(fileURLWithPath: "/System/Applications/Mail.app"))!
    
    @State private var currentTime = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var onContinue: () -> Void
    
    private var appsListView: some View {
        VStack(spacing: 0) {
            CreateLaunchItemView(
                launchURL: .constant(selectedApp?.url),
                onDelete: { })
                .disabled(true)
            Divider()
            Button(action: {}) {
                Image(systemName: "plus.circle")
                    .frame(width: 24, height: 24)
                Text("Add item")
                Spacer()
            }
            .buttonStyle(NavigationLinkButtonStyle())
            .cornerRadius(8)
            .disabled(true)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("You're all set!")
                .font(.headline.italic())
            Text("Here's how you create your first launcher")
                .font(.caption)
                .padding(.bottom, 16)
            
            Text("1. Name your launcher")
            Text("For example _Work_")
                .font(.caption)
                .padding(.bottom, 16)
            
            Text("2. Add apps to your first launcher")
            appsListView
            
            VStack {
                Text("3. Run your launcher any time from the menu bar icon")
                HStack(alignment: .center) {
                    Spacer()
                    Image(systemName: menuBarIcon)
                        .padding(.horizontal)
                    Text(currentTime.formatted(.dateTime.hour().minute()))
                        .monospacedDigit()
                        .onReceive(timer) { _ in
                            currentTime = Date()
                        }
                }
                .padding(.horizontal)
                .frame(height: 22)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(.blue.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.top, 2)
            }
            .padding(.vertical, 16)
            
            GradientButton(action: onContinue, text: "Create first launcher")
                .padding(.top, 8)
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}



struct GradientButton: View {
    var action: () -> Void
    var text: String
    var body: some View {
        Button(action: action) {
            Text(text)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(.blue.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
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
            Text("Let's get you started")
                .font(.subheadline)
            
            GradientButton(action: onStart, text: "Continue")
                .padding()
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
    InfoView(onContinue: {})
}

#Preview {
    OnboardingView(onOnboardingComplete: {})
}
