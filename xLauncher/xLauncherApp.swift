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
        MenuBarExtra("xLauncher", systemImage: "dot.scope.laptopcomputer") {
            AppMenu()
        }
        
        Window("Settings", id: "settings") {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct AppMenu: View {
    @Environment(\.openWindow) var openWindow

    func launchAction() {
        let url = NSURL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app", isDirectory: true) as URL
        
        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
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
        Button(action: launchAction, label: { Text("Terminal") })
        
        Divider()

        Button(action: launchSettings, label: { Text("Settings...") })
    }
}
