//
//  Settings.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-20.
//

import SwiftUI
import LaunchAtLogin
import SymbolPicker

struct Settings: View {
    
    @State private var iconPickerPresented = false
    @AppStorage("menu-bar-icon") var menuBarIcon: String = "dot.scope.laptopcomputer"
    
    var launchAtLoginToggle: some View {
        LaunchAtLogin.Toggle() {
            HStack {
                Text("Launch at Login")
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
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 0) {
                launchAtLoginToggle
                
                Divider()
                
                menuBarIconPicker
            }
            .frame(maxWidth: .infinity)
            .sectionStyle()
            
            Spacer()
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("xLauncher")
            }.frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    Settings()
}
