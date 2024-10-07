//
//  FileManager.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-06.
//

import Foundation
import SwiftUI

struct InstalledApp : Identifiable {
    var id: String {
        self.name
    }
    var name: String
    var icon: NSImage?
    var path: String
}

extension FileManager {
    
    private func getAppsInDir(path: URL) -> [InstalledApp] {
        var appNames = [InstalledApp]()

        if let enumerator = self.enumerator(at: path, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants) {
            while let element = enumerator.nextObject() as? URL {
                if element.pathExtension == "app" {
                    appNames.append(getAppByPath(path: element)!)
                }
            }
        }
        return appNames
    }
    
    func getAppByPath(path: URL) -> InstalledApp? {
        if let bundle = Bundle(url: path) {
            return InstalledApp(name: path.deletingPathExtension().lastPathComponent, icon: bundle.appIcon, path: bundle.bundlePath)
        }
        return nil
    }

    func getInstalledApps() -> [InstalledApp] {
        var appNames = [InstalledApp]()
        
        let systemApplicationsUrl = URL(string: "/System/Applications/")
        if let url = systemApplicationsUrl {
            appNames.append(contentsOf: getAppsInDir(path: url))
        }
        
        if let url = self.urls(for: .applicationDirectory, in: .localDomainMask).first {
            appNames.append(contentsOf: getAppsInDir(path: url))
        }
        
        return appNames
    }
}
