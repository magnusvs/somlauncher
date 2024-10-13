//
//  AppMenu.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-04.
//

import SwiftUI
import SwiftData

struct AppMenu: View {
    @Environment(\.openWindow) var openWindow
    @Query var launcherScripts: [LauncherScript]

    func launchAction() {
        AppLauncher.launchApp(url: URL(filePath: "/System/Applications/Utilities/Terminal.app")!)
    }

    func launchSettings() {
        NSApplication.shared.activate(ignoringOtherApps: true)
        openWindow(id: "settings")
        NSApplication.shared.windows.forEach { window in
            if window.identifier?.rawValue.elementsEqual("settings") ?? false {
                window.makeKeyAndOrderFront(nil)
                window.orderFrontRegardless()
                return
            }
        }
    }

    var body: some View {
        if (launcherScripts.isEmpty) {
            Button(action: launchSettings, label: { Text("Create your first Launcher") })
        }

        ForEach(launcherScripts) { launcherScript in
            Button(action: {
                AppLauncher.launchScript(script: launcherScript)
            }, label: { Text(launcherScript.name) })
        }
        
        Divider()

        Button(action: launchSettings, label: { Text("Settings...") })
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }.keyboardShortcut("q")
    }
}
