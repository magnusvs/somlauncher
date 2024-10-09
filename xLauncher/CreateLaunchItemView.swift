//
//  CreateLaunchItemView.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-07.
//
import SwiftUI
import Foundation


struct CreateLaunchItemView: View {
    @State private var selectedType = LaunchActionType.App
    @State private var selectedApp: InstalledApp? = nil
    @State private var urlInput: String = ""
    
    @State private var showDelete: Bool = false

    @State private var isSheetOpened = false
    private let allApps: [InstalledApp]
    private var onDelete: () -> Void
    
    init(onDelete: @escaping () -> Void) {
        self.onDelete = onDelete
        allApps = FileManager.default.getInstalledApps().sorted(by: { left, right in
            return left.name < right.name
        })
    }
    
    var body: some View {
        HStack(alignment: .center) {
//            Picker("Type", selection: $selectedType) {
//                Text("App").tag(LaunchActionType.App)
//                Text("Url").tag(LaunchActionType.Url)
//            }
//            .pickerStyle(.radioGroup)
//            Spacer(minLength: 16)
            if selectedType == LaunchActionType.Url {
                HStack {
                    TextField(
                        "Url",
                        text: $urlInput,
                        prompt: Text("https://example.com")
                    )
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 300, minHeight: 24)
                    
                    Button(
                        action: { Launcher.openUrl(url: urlInput) },
                        label: {
                            Label("Test", systemImage: "arrow.up.right.square")
                                .labelStyle(ReversedLabelStyle())
                        }
                    )
                    .buttonStyle(.link).tint(.gray)
                }
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
                    Spacer()
                }
                .contentShape(Rectangle())
                .buttonStyle(.plain)
                .sheet(isPresented: $isSheetOpened) {
                    SelectAppSheet(apps: self.allApps, selectedApp: self.$selectedApp)
                        .frame(width: 400, height: 600)
                }
            }
            if (showDelete) {
                Button(action: self.onDelete) {
                    Image(systemName: "minus.circle")
                }
                .buttonStyle(.plain)
            }
        }.onHover(perform: { over in showDelete = over })
    }
}

#Preview {
    ScrollView {
        CreateLaunchItemView(onDelete: {})
    }
}
