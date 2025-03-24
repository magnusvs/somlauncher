//
//  SomLauncherApp.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-03.
//

import SwiftUI
import Foundation
import SwiftData

@main
struct SomLauncherMain {
    
    static func main() {
        if (UserDefaults.standard.bool(forKey: "onboarding-complete")) {
            SomLauncherApp.main()
        } else {
            SomLauncherAppWithOnboarding.main()
        }
    }
}

struct SomLauncherCommonScene: Scene {
    
    var container: ModelContainer
    var menuBarIcon: String
    
    var body: some Scene {
        MenuBarExtra("SomLauncher", systemImage: menuBarIcon) {
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

struct SomLauncherAppWithOnboarding : App {
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
                onboardingComplete = true
                openWindow(id: "settings")
                dismissWindow(id: "onboarding")
            })
        }
        .windowStyle(.hiddenTitleBar)
        
        SomLauncherCommonScene(
            container: container, menuBarIcon: menuBarIcon
        )
    }
}

struct SomLauncherApp : App {
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
        SomLauncherCommonScene(
            container: container, menuBarIcon: menuBarIcon
        )
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
