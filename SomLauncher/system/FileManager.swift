//
//  FileManager.swift
//  SomLauncher
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
    var url: URL
    var secureAccess: Bool = false
}

extension FileManager {
    
    private func getAppsInDir(path: URL, secureAccess: Bool = false) -> [InstalledApp] {
        var appNames = [InstalledApp]()

        if let enumerator = self.enumerator(at: path, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants) {
            while let element = enumerator.nextObject() as? URL {
                if element.pathExtension == "app" {
                    if let app = getAppByUrl(url: element) {
                        appNames.append(app)
                    }
                }
            }
        }
        return appNames
    }
    
    func getAppByUrl(url: URL, secureAccess: Bool = false) -> InstalledApp? {
        if let bundle = Bundle(url: url) {
            return InstalledApp(name: url.deletingPathExtension().lastPathComponent, icon: bundle.appIcon, url: bundle.bundleURL, secureAccess: secureAccess)
        }
        return nil
    }

    // TODO: Fix Books application not showing image for some reason
    func getInstalledApps(sorted: Bool = false) -> [InstalledApp] {
        var appNames = [InstalledApp]()
        
        let systemApplicationsUrl = URL(string: "/System/Applications/")
        if let url = systemApplicationsUrl {
            appNames.append(contentsOf: getAppsInDir(path: url))
        }
        
        if let url = self.urls(for: .applicationDirectory, in: .localDomainMask).first {
            appNames.append(contentsOf: getAppsInDir(path: url))
        }
        
        if let url = ApplicationsFolderFileBookmark.resolve() {
            if (url.startAccessingSecurityScopedResource()) {
                appNames.append(contentsOf: getAppsInDir(path: url, secureAccess: true))
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        if (sorted) {
            return appNames.sorted(by: { left, right in return left.name < right.name })
        }
        return appNames
    }
}
