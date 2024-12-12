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
    
    @AppStorage("menu-bar-icon") private var menuBarIcon: String = "dot.scope.display"
    @AppStorage("onboarding-complete") private var onboardingComplete: Bool = false
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        do {
            container = try ModelContainer(for: LauncherScript.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        Window("Onboarding", id: "onboarding") {
            OnboardingView(onOnboardingComplete: {
                openWindow(id: "settings")
                dismissWindow(id: "onboarding")
            })
        }
        .windowStyle(.hiddenTitleBar)

        MenuBarExtra("xLauncher", systemImage: menuBarIcon) {
            AppMenu()
                .modelContainer(container)
        }
        
        Window("Settings", id: "settings") {
            ContentView()
                .modelContainer(container)
                .toolbarBackground(.clear)
        }
        .windowStyle(.hiddenTitleBar)
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
