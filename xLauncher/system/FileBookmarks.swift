//
//  FileBookmarks.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-11-16.
//
import SwiftUI

struct FileBookmarks {
    
    static let keyBookmarkUserApplications = "UserApplicationsFolderBookmark"
    
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
                saveBookmarkForUrl(at: resolvedUrl, key: key)
            }
            
            return resolvedUrl
        } catch {
            print("Error resolving url for key \(key): \(error)")
        }
        return nil
    }
}
