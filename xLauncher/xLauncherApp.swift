//
//  xLauncherApp.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-03.
//

import SwiftUI
import Foundation
import SwiftData

@main
struct xLauncherApp: App {
    let container: ModelContainer
    
    @AppStorage("menu-bar-icon") var menuBarIcon: String = "dot.scope.laptopcomputer"
    @AppStorage("show-dock-icon") var showDockIcon: Bool = false
    
    init() {
        do {
            container = try ModelContainer(for: LauncherScript.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        Window("Settings", id: "settings") {
            ContentView()
                .modelContainer(container)
                .toolbarBackground(.clear)
        }

        MenuBarExtra("xLauncher", systemImage: menuBarIcon) {
            AppMenu()
                .modelContainer(container)
        }.onChange(of: showDockIcon, initial: showDockIcon) { old, newShow in
            if (newShow) {
                NSApp.setActivationPolicy(.regular)
                NSApp.dockTile.contentView = NSHostingView(rootView: DockIcon())
                NSApp.dockTile.display()
            } else {
                NSApp.setActivationPolicy(.accessory)
                NSApp.activate()
            }
            
        }
    }
}
