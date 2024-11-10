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
    @State private var isFileImporterOpened = false
    private let allApps: [InstalledApp] = InstalledApp.allInstalledApps
    private var onDelete: () -> Void
    
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
                    if let icon = selectedApp?.icon {
                        Image(nsImage: icon)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    if let name = selectedApp?.name {
                        Text(name)
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
            .sheet(isPresented: $isAppsSheetOpened) {
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
                    onFileSelected: {
                        isFileImporterOpened.toggle()
                    }
                )
                .frame(width: 400, height: 600)
            }
            .sheet(isPresented: $isUrlSheetOpened, content: {
                UrlInputSheet { url in
                    selectedType = LaunchActionType.Url
                    urlInput = url
                }
            })
            .fileImporter(isPresented: $isFileImporterOpened, allowedContentTypes: [.application], onCompletion: { result in
                switch result {
                case .success(let url):
                    print(url)
                    if let app = FileManager.default.getAppByUrl(url: url) {
                        print(app)
                        selectedType = LaunchActionType.App
                        selectedApp = app
                        launchURL = app.url
                    }
                    url.stopAccessingSecurityScopedResource()
                    case .failure:
                        // We ignore error
                        break
                }
            })
        .onHover(perform: { over in showDelete = over })
        .buttonStyle(NavigationLinkButtonStyle())
    }
}

#Preview {
    VStack {
        CreateLaunchItemView(launchURL: .init(get: { URL(string: "https://www.test.com") }, set: { _ in }), onDelete: {})
        CreateLaunchItemView(launchURL: .constant(nil), onDelete: {})
    }
}
