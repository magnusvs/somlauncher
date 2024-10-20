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
        }
        .windowStyle(.hiddenTitleBar)

        MenuBarExtra("xLauncher", systemImage: "dot.scope.laptopcomputer") {
            AppMenu()
                .modelContainer(container)
        }
    }
}
