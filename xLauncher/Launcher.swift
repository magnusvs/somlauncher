//
//  Launcher.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-07.
//
import SwiftUI

struct LaunchAction : Hashable, Identifiable {
    var id: UUID = UUID()
    var url: URL?
}

class Launcher {
    
    static func openAction(action: LaunchAction) {
        if let url = action.url {
            if (url.isFileURL) {
                launchApp(url: url)
            } else {
                openUrl(url: url.absoluteString)
            }
        }
    }
    
    static func openUrl(url: String) {
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
