//
//  ContentView.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-03.
//

import SwiftUI
import AppKit
import SwiftData

enum Screen : Hashable {
    case Launcher(launcherScript: LauncherScript?)
    case Settings
}

struct ContentView: View {
    @Query var launcherScripts: [LauncherScript]
    @State private var selection: Screen = Screen.Launcher(launcherScript: nil)
    
    @State private var expanded = true
    
    var body: some View {
        NavigationSplitView() {
            List(selection: $selection) {
                DisclosureGroup(isExpanded: $expanded) {
                    ForEach(launcherScripts) { launcherScript in
                        NavigationLink(value: Screen.Launcher(launcherScript: launcherScript)) {
                            Label(launcherScript.name, systemImage: "hammer")
                        }
                    }
                    NavigationLink(value: Screen.Launcher(launcherScript: nil)) {
                        Label("New", systemImage: "plus")
                    }
                } label: {
                    Label("Launchers", systemImage: "list.bullet")
                }
                    NavigationLink(value: Screen.Settings) {
                        Label("Settings", systemImage: "gear")
                    }
                    
            }
        } detail: {
            switch selection {
            case .Launcher(let launcherScript):
                LaunchBuilderView(
                    selectedLauncher: Binding(get: { launcherScript }, set: { selection = .Launcher(launcherScript: $0) } ))
                .navigationTitle(Text("Launcher"))
            case .Settings:
                Settings()
                    .navigationTitle(Text("Settings"))
            }
            
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

#Preview {
    ContentView()
}
