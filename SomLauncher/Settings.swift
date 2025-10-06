//
//  Settings.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-20.
//

import LaunchAtLogin
import SwiftUI
import SymbolPicker

struct Settings: View {
    @State private var iconPickerPresented = false
    @AppStorage("menu-bar-icon") var menuBarIcon: String = "RocketIcon"
    @AppStorage("menu-bar-icon-custom") var menuBarIconShowCustom: Bool = false
    @AppStorage("show-dock-icon") var showDockIcon: Bool = false
    var launchAtLoginToggle: some View {
        LaunchAtLogin.Toggle {
            HStack {
                Text("Start SomLauncher at Login")
                Spacer()
            }
        }
        .toggleStyle(.switch)
        .controlSize(.mini)
    }
    
    var menuBarCustomEnabled: some View {
        HStack {
            Toggle(
                isOn: $menuBarIconShowCustom,
                label: {
                    HStack {
                        Text("Custom menu bar icon")
                        Spacer()
                    }
                }
            )
            .toggleStyle(.switch)
            .controlSize(.mini)
        }
        .onChange(of: menuBarIconShowCustom, initial: menuBarIconShowCustom) { old, newShow in
            if (newShow) {
                menuBarIcon = "dot.scope.display"
            } else {
                menuBarIcon = "RocketIcon"
            }
        }
    }

    var menuBarIconPicker: some View {
        NavigationLink(value: "") {
            LabeledContent("Menu bar icon") {
                if (menuBarIcon == "RocketIcon") {
                    Image(menuBarIcon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                } else {
                    Image(systemName: menuBarIcon)
                }
            }
        }
        .disabled(!menuBarIconShowCustom)
        .simultaneousGesture(TapGesture().onEnded { iconPickerPresented = true })
        .sheet(isPresented: $iconPickerPresented) {
            SymbolPicker(symbol: $menuBarIcon)
        }
    }

    var showInDockToggle: some View {
        HStack {
            Toggle(
                isOn: $showDockIcon,
                label: {
                    HStack {
                        Text("Show icon in dock")
                        Spacer()
                    }
                }
            )
            .toggleStyle(.switch)
            .controlSize(.mini)
        }
        .onChange(of: showDockIcon, initial: showDockIcon) { old, newShow in
            if newShow {
                NSApp.setActivationPolicy(.regular)
            } else {
                NSApp.setActivationPolicy(.accessory)
                NSApp.activate()
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Form {
                launchAtLoginToggle
                menuBarCustomEnabled
                menuBarIconPicker
                showInDockToggle
            }
            .formStyle(.grouped)

            Spacer()

            VStack {
                Image("LauncherIcon")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("SomLauncher")
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    Settings()
}
