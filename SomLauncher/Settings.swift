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
    @AppStorage("menu-bar-icon") var menuBarIcon: String = "dot.scope.display"
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

    var menuBarIconPicker: some View {
        NavigationLink(value: "") {
            LabeledContent("Menu bar icon") {
                Image(systemName: menuBarIcon)
            }
        }
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

    func setDockIcon() {
        let icon = DockIcon()
        let iconImage = icon.asImage(pixelWidth: 512, pixelHeight: 512)
        print(
            NSWorkspace.shared.setIcon(
                iconImage,
                forFile: Bundle.main.bundlePath,
                options: []
            )
        )
        NSApp.dockTile.contentView = NSHostingView(rootView: icon)
        NSApp.dockTile.display()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Form {
                launchAtLoginToggle
                menuBarIconPicker
                showInDockToggle
            }
            .formStyle(.grouped)

            Spacer()

            VStack {
                Image(systemName: "dot.scope.display")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("SomLauncher")
            }.frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    Settings()
}
