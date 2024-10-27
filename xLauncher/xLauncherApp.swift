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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        if (UserDefaults.standard.bool(forKey: "show-dock-icon")) {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
            NSApp.activate()
        }
    }
}
