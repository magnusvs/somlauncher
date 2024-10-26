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
    @AppStorage("show-dock-icon") var showDockIcon: Bool = false
    
    var launchAtLoginToggle: some View {
        LaunchAtLogin.Toggle() {
            HStack {
                Text("Start xLauncher at Login")
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
