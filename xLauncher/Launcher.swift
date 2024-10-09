//
//  Launcher.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-07.
//
import SwiftUI

class Launcher {
    
    static func openUrl(url: String) {
        if let url = URL(string: url) {
            NSWorkspace.shared.open(url)
        }
    }
    
    static func launchApp(path: String) {
        let url = NSURL(fileURLWithPath: path, isDirectory: true) as URL
        
        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
    }
}
