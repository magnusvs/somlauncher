//
//  AppMenu.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-04.
//

import SwiftUI

struct AppMenu: View {
    @Environment(\.openWindow) var openWindow

    func launchAction() {
        Launcher.launchApp(url: URL(filePath: "/System/Applications/Utilities/Terminal.app")!)
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
