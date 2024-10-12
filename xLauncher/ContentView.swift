//
//  ContentView.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-03.
//

import SwiftUI
import AppKit

enum Screen : String, Hashable, CaseIterable {
    case Launcher
    case Settings
}

struct ContentView: View {
    @State private var selection: Screen = Screen.Launcher
    
    var body: some View {
        NavigationSplitView() {
            List(Screen.allCases, id: \.self, selection: $selection) { screen in
                NavigationLink(screen.rawValue, value: screen)
            }
        } detail: {
            switch selection {
            case .Launcher:
                LaunchBuilderView()
            case .Settings:
                Settings()
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct LaunchAction : Hashable {
    var id: UUID
    var type: LaunchActionType
    var url: URL
}

enum LaunchActionType : String {
    case Url
    case App
}

struct LaunchBuilderView: View {
    @State private var nameInput: String = ""
    @State private var actions: [LaunchAction] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Build your launcher")
                    .font(.headline)
                Text("Build your custom launching script by adding Apps or URLs to the list. These will all be opened when the launcher is run.")
                    .font(.subheadline)
                
                Spacer(minLength: 16)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(actions, id: \.self) { action in
                        CreateLaunchItemView(onDelete: { actions.remove(at: actions.firstIndex(of: action)!) })
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                        Divider()
                    }
                    Button(action: {
                        actions.append(LaunchAction(id: UUID.init(), type: LaunchActionType.Url, url: URL(filePath: "https://example.com")!))
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Add item")
                    }
                    .foregroundColor(.gray)
                    .buttonStyle(NavigationLinkButtonStyle(showChevron: false))
                    .cornerRadius(8)
                    
                }
                .frame(maxWidth: .infinity)
                .sectionStyle()
                .animation(.easeInOut, value: actions)
                
                Spacer(minLength: 32)
                Text("Name")
                    .font(.subheadline)
                TextField("", text: $nameInput, prompt: Text("Required"))
                    .textFieldStyle(.roundedBorder)
                
                Spacer(minLength: 8)
                
                Button(action: {}, label: { Text("Save") }).buttonStyle(.borderedProminent)
                    .disabled(nameInput.count <= 0)
            }.padding()
        }
    }
}

struct Settings: View {
    @State private var urlInput: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("xLauncher")
        }
    }
}

#Preview {
    ContentView()
}
