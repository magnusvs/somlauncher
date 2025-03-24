//
//  AppLauncher.swift
//  SomLauncher
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
