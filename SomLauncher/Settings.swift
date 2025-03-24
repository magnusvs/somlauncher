//
//  Settings.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-20.
//

import SwiftUI
import LaunchAtLogin
import SymbolPicker

struct Settings: View {
    
    @State private var iconPickerPresented = false
    @AppStorage("menu-bar-icon") var menuBarIcon: String = "dot.scope.display"
    @AppStorage("show-dock-icon") var showDockIcon: Bool = false
    
    var launchAtLoginToggle: some View {
        LaunchAtLogin.Toggle() {
            HStack {
                Text("Start SomLauncher at Login")
                Spacer()
            }
        }
        .toggleStyle(.switch)
        .controlSize(.mini)
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
    }
    
    var menuBarIconPicker: some View {
        Button {
            iconPickerPresented = true
        } label: {
            Text("Menu bar icon")
            Spacer()
            Image(systemName: menuBarIcon)
        }
        .sheet(isPresented: $iconPickerPresented) {
            SymbolPicker(symbol: $menuBarIcon)
        }
        .buttonStyle(NavigationLinkButtonStyle())
    }
    
    var showInDockToggle: some View {
        HStack {
            Toggle(isOn: $showDockIcon, label: {
                HStack {
                    Text("Show icon in dock")
                    Spacer()
                }
            })
            .toggleStyle(.switch)
            .controlSize(.mini)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .onChange(of: showDockIcon, initial: showDockIcon) { old, newShow in
            if (newShow) {
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
        print(NSWorkspace.shared.setIcon(iconImage, forFile: Bundle.main.bundlePath, options: []))
        NSApp.dockTile.contentView = NSHostingView(rootView: icon)
        NSApp.dockTile.display()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 0) {
                launchAtLoginToggle
                
                Divider()
                
                menuBarIconPicker
                
                Divider()
                
                showInDockToggle
            }
            .frame(maxWidth: .infinity)
            .sectionStyle()
            
            Spacer()
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("SomLauncher")
            }.frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    Settings()
}
