//
//  AppLauncher.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-07.
//
import SwiftUI
import SwiftData

@Model class LauncherScript {
    var name: String
    var items: [Item]
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
    
    @Model class Item {
        @Attribute(.unique) var id: UUID = UUID()
        var url: URL
        
        init(id: UUID = UUID(), url: URL) {
            self.id = id
            self.url = url
        }
    }

}

struct LaunchAction : Hashable, Identifiable {
    var id: UUID = UUID()
    var url: URL?
}

class AppLauncher {
    
    static func launchScript(script: LauncherScript) {
        script.items.forEach { item in
            openAction(action: item)
        }
    }
    
    static func openAction(action: LauncherScript.Item) {
        openURL(url: action.url)
    }
    
    static func openAction(action: LaunchAction) {
        if let url = action.url {
            openURL(url: url)
        }
    }
    
    static func openURL(url: URL) {
        if (url.isFileURL) {
            launchApp(url: url)
        } else {
            openWebUrl(url: url.absoluteString)
        }
    }
    
    static func openWebUrl(url: String) {
        if let url = URL(string: url) {
            NSWorkspace.shared.open(url)
        }
    }
    
    static func launchApp(url: URL) {
        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
    }
}
