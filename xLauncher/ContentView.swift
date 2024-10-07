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

struct LaunchAction {
    var type: LaunchActionType
    var url: URL
}

enum LaunchActionType : String {
    case Url
    case App
}

struct LaunchBuilderView: View {
    @State private var urlInput: String = ""
    private let allApps: [InstalledApp]
    
    init() {
        allApps = FileManager.default.getInstalledApps().sorted(by: { left, right in
            return left.name < right.name
        })
    }
    
    func openUrl(url: String) {
        if let url = URL(string: url) {
            NSWorkspace.shared.open(url)
        }
    }
    
    
    func launchAction(path: String) {
        let url = NSURL(fileURLWithPath: path, isDirectory: true) as URL
        
        let path = "/bin"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
    }

    @State var isSheetOpened = false
    @State var selectedApp: InstalledApp? = nil
    
    @State var selectedType = LaunchActionType.App
    
    @State private var nameInput: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Build your launcher")
                    .font(.headline)
                
                TextField("", text: $nameInput, prompt: Text("Name"))
                    .textFieldStyle(.roundedBorder)
                
                Spacer(minLength: 16)
                
                VStack(alignment: .leading) {
                    Picker("Type", selection: $selectedType) {
                        Text("App").tag(LaunchActionType.App)
                        Text("Url").tag(LaunchActionType.Url)
                    }
                    Spacer(minLength: 16)
                    if selectedType == LaunchActionType.Url {
                        TextField(
                            "Url",
                            text: $urlInput,
                            prompt: Text("https://example.com")
                        )
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 300)
                        
                        Button(action: { openUrl(url: urlInput) }, label: { Text("Launch") }).buttonStyle(.borderless).tint(.gray)
                    } else {
                        Button(action: {isSheetOpened.toggle()}) {
                            if let icon = selectedApp?.icon {
                                Image(nsImage: icon)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            } else {
                                Image(systemName: "app")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.gray)
                            }
                            
                            if let name = selectedApp?.name {
                                Text(name)
                            } else {
                                Text("Select app")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .buttonStyle(.plain)
                        .sheet(isPresented: $isSheetOpened) {
                            SelectAppSheet(apps: self.allApps, selectedApp: self.$selectedApp)
                                .frame(width: 400, height: 600)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .sectionStyle()
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
