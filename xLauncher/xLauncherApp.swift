//
//  xLauncherApp.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-03.
//

import SwiftUI
import Foundation

@main
struct xLauncherApp: App {
    var body: some Scene {
        Window("Settings", id: "settings") {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)

        MenuBarExtra("xLauncher", systemImage: "dot.scope.laptopcomputer") {
            AppMenu()
        }
    }
}
