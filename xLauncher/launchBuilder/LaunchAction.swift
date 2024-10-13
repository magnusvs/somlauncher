//
//  LaunchAction.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-13.
//
import SwiftUI

struct LaunchAction : Hashable, Identifiable {
    var id: UUID = UUID()
    var url: URL?
}
