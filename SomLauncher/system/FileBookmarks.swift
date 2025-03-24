//
//  FileBookmarks.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-11-16.
//
import SwiftUI

struct FileBookmarks {
    
    static func saveBookmarkForUrl(at url: URL, key: String) -> Bool {
        do {
            let bookmarkData = try url.bookmarkData(options: [.withSecurityScope], includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(bookmarkData, forKey: key)
            return true
        } catch {
            print("Error creating bookmark data: \(error)")
            return false
        }
    }
    
    static func resolveBookmark(for key: String) -> URL? {
        guard let bookmarkData = UserDefaults.standard.data(forKey: key) else { return nil }
        var isStale = false
        do {
            let resolvedUrl = try URL(resolvingBookmarkData: bookmarkData, options: [.withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &isStale)
            if isStale {
                let saved = saveBookmarkForUrl(at: resolvedUrl, key: key)
                if (!saved) {
                    return nil
                }
            }
            
            return resolvedUrl
        } catch {
            print("Error resolving url for key \(key): \(error)")
        }
        return nil
    }
}

struct ApplicationsFolderFileBookmark {
    private static let keyBookmarkUserApplications = "UserApplicationsFolderBookmark"

    static func hasAccess() -> Bool {
        FileBookmarks.resolveBookmark(for: keyBookmarkUserApplications) != nil
    }
    
    static func resolve() -> URL? {
        FileBookmarks.resolveBookmark(for: keyBookmarkUserApplications)
    }

    static func requestAccess() -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.title = "Please grant access to the Applications folder"
        openPanel.message = "SomLauncher needs access to your Applications folder to list all apps"
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        let applicationsUrl = URL(fileURLWithPath: ("~/Applications" as NSString).expandingTildeInPath)
        openPanel.directoryURL = applicationsUrl
        
        let response = openPanel.runModal()
        
        if response == .OK {
            if let url = openPanel.url {
                if (url.absoluteString.lowercased().hasSuffix("/applications/") && FileBookmarks.saveBookmarkForUrl(at: url, key: keyBookmarkUserApplications)) {
                    return url
                }
            }
        }
        return nil
    }
}
