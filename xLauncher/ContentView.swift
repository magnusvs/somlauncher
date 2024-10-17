//
//  ContentView.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-03.
//

import SwiftUI
import AppKit
import LaunchAtLogin

enum Screen : String, Hashable, CaseIterable {
    case Launcher
    case Settings
}

struct ContentView: View {
    @State private var selection: Screen = Screen.Launcher
    
    var body: some View {
        NavigationSplitView() {
            List(Screen.allCases, id: \.self, selection: $selection) { screen in
                NavigationLink(screen.rawValue, value: screen)
            }
        } detail: {
            switch selection {
            case .Launcher:
                LaunchBuilderView()
            case .Settings:
                Settings()
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct Settings: View {
    @State private var urlInput: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("xLauncher")
            
            Form {
                LaunchAtLogin.Toggle()
                    .toggleStyle(.switch)
            }
        }
    }
}

#Preview {
    ContentView()
}
