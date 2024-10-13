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

enum LaunchActionType : String {
    case Url
    case App
}

struct LaunchBuilderView: View {
    @State private var nameInput: String = ""
    @State private var actions: [LaunchAction] = []
    @State private var showLaunchConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Build your launcher")
                    .font(.headline)
                Text("Build your custom launching script by adding Apps or URLs to the list. These will all be opened when the launcher is run.")
                    .font(.subheadline)
                
                Spacer(minLength: 16)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach($actions) { $action in
                        CreateLaunchItemView(
                            launchURL: $action.url,
                            onDelete: { actions.remove(at: actions.firstIndex(of: action)!) })
                        Divider()
                    }
                    Button(action: {
                        actions.append(LaunchAction(url: nil)) // TODO update from CreateLaunchItemView somehow
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Add item")
                        Spacer()
                    }
                    .foregroundColor(.gray)
                    .buttonStyle(NavigationLinkButtonStyle(showChevron: false))
                    .cornerRadius(8)
                    
                }
                .frame(maxWidth: .infinity)
                .sectionStyle()
                .animation(.easeInOut, value: actions)
                
                Spacer()
                Button(action: {
                    showLaunchConfirmation.toggle()
                }, label: {
                    Label("Run", systemImage: "chevron.right")
                        .labelStyle(ReversedLabelStyle())
                })
                .disabled(actions.isEmpty)
                .padding(.horizontal, 12)
                .buttonStyle(.plain)
                .alert(
                    "Launch all your actions?",
                    isPresented: $showLaunchConfirmation
                ) {
                    Button("Cancel", role: .cancel) {}
                    Button("Launch") {
                        actions.forEach { action in
                            Launcher.openAction(action: action)
                        }
                    }
                }
                
                
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
