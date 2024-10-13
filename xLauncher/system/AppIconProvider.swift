//
//  AppIconProvider.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-05.
//

import SwiftUI
import Foundation

extension Bundle {
    var appIcon: NSImage? {
        if let appIcon = image(forResource: "AppIcon") {
            return appIcon
        }
        
        return NSWorkspace.shared.icon(forFile: bundlePath)
    }
}
