//
//  CreateLaunchItemView.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-07.
//
import SwiftUI
import Foundation

enum LaunchActionType : String {
    case Url
    case App
}

func requestAccessToApplicationsFolder() -> URL? {
    let openPanel = NSOpenPanel()
    openPanel.title = "Please grant access to the Applications folder"
    openPanel.message = "xLauncher needs access to your Applications folder to list all apps"
    openPanel.canChooseFiles = false
    openPanel.canChooseDirectories = true
    openPanel.allowsMultipleSelection = false
    let applicationsUrl = URL(fileURLWithPath: ("~/Applications" as NSString).expandingTildeInPath)
    openPanel.directoryURL = applicationsUrl
    
    let response = openPanel.runModal()
    
    if response == .OK {
        if let url = openPanel.url {
            if (url.absoluteString.lowercased().hasSuffix("/applications/") && FileBookmarks.saveBookmarkForUrl(at: url, key: FileBookmarks.keyBookmarkUserApplications)) {
                return url
            }
        }
    }
    return nil
}

func hasApplicationsFolderAccess() -> Bool {
    FileBookmarks.resolveBookmark(for: FileBookmarks.keyBookmarkUserApplications) != nil
}

struct CreateLaunchItemView: View {
    @State private var selectedType: LaunchActionType? = nil
    @State private var selectedApp: InstalledApp? = nil
    @State private var urlInput: String = "" {
        didSet {
            launchURL = URL(string: urlInput)
        }
    }
    
    @State private var showDelete: Bool = false
    @Binding private var launchURL: URL?

    @State private var isAppsSheetOpened = false
    @State private var isUrlSheetOpened = false
    @State private var allApps: [InstalledApp] = FileManager.default.getInstalledApps(sorted: true)
    private var onDelete: () -> Void
    
    @State private var hasApplicationFolderAccess: Bool = hasApplicationsFolderAccess()
    
    init(
        launchURL: Binding<URL?>,
        onDelete: @escaping () -> Void
    ) {
        self._launchURL = launchURL
        self.onDelete = onDelete
        if let url = launchURL.wrappedValue {
            if (url.isFileURL) {
                _selectedType = State(initialValue: LaunchActionType.App)
                _selectedApp = State(initialValue: allApps.first(where: { url == $0.url}))
            } else {
                _selectedType = State(initialValue: LaunchActionType.Url)
                _urlInput = State(initialValue: url.absoluteString)
            }
        }
    }
    
    var selectAppSheet: some View {
        SelectAppSheet(
            apps: self.allApps,
            onAppSelected: { app in
                selectedType = LaunchActionType.App
                selectedApp = app
                launchURL = app.url
            },
            onUrlSelected: {
                isUrlSheetOpened.toggle()
            },
            onAllowUserApps: {
                if requestAccessToApplicationsFolder() != nil {
                    withAnimation {
                        allApps = FileManager.default.getInstalledApps(sorted: true)
                        hasApplicationFolderAccess = true
                    }
                }
            },
            hasUserApplicationsAccess: hasApplicationFolderAccess
        )
        .apply {
            if #available(macOS 15.0, *) {
                $0.presentationSizing(.form)
            }
        }
    }
    
    var urlInputSheet: some View {
        UrlInputSheet { url in
            selectedType = LaunchActionType.Url
            urlInput = url
        }
    }
    
    var body: some View {
        Button(action: {isAppsSheetOpened.toggle()}) {
            switch selectedType {
            case nil:
                Image(systemName: "app")
                    .font(.system(size: 26))
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
                Text("Select app")
                    .foregroundColor(.gray)
            case .App:
                if let app = selectedApp {
                    if let icon = app.icon {
                        Image(nsImage: icon)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(app.name)
                } else {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 20))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray)
                    Text("Could not read application")
                        .foregroundStyle(.gray)
                }
                
            case .Url:
                Image(systemName: "network")
                    .font(.system(size: 20))
                    .frame(width: 24, height: 24)
                Button(action: { AppLauncher.openWebUrl(url: urlInput) }){
                    Text(urlInput)
                }
                .buttonStyle(.link)
            }
            
            Spacer()
            if (showDelete) {
                Button(action: self.onDelete) {
                    Image(systemName: "minus.circle")
                }
                .buttonStyle(.plain)
            }
        }
        .contentShape(Rectangle())
        .onHover(perform: { over in showDelete = over })
        .buttonStyle(NavigationLinkButtonStyle())
        .sheet(isPresented: $isAppsSheetOpened) { selectAppSheet }
        .sheet(isPresented: $isUrlSheetOpened) { urlInputSheet }
    }
}

#Preview {
    VStack {
        CreateLaunchItemView(launchURL: .init(get: { URL(string: "https://www.test.com") }, set: { _ in }), onDelete: {})
        CreateLaunchItemView(launchURL: .constant(nil), onDelete: {})
    }
}
