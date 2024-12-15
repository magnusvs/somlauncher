//
//  SelectAppSheet.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-06.
//
import SwiftUI

struct SelectAppSheet: View {
    @Environment(\.dismiss) private var dismiss

    var apps : [InstalledApp]
    var onAppSelected: (InstalledApp) -> Void
    var onUrlSelected: () -> Void
    var onAllowUserApps: () -> Void
    var hasUserApplicationsAccess: Bool

    var userAppsWarning: some View {
        VStack(alignment: .leading) {
            Text("Some applications might not be listed until you allow access to the applications folder")
                .font(.subheadline)
            Button(action: { onAllowUserApps() }) {
                Text("Allow access")
                Image(systemName: "chevron.right").font(.body)
            }
            .padding(.top)
            .buttonStyle(.plain)
        }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .foregroundStyle(.red)
            .background(.red.quinary)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.red.quaternary, lineWidth: 1))
            .transition(.offset(x: 0, y: -48).combined(with: .opacity))
    }
    
    var webUrlButton: some View {
        Button(action: {
            onUrlSelected()
            dismiss()
        }, label: {
            Image(systemName: "network")
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
            Text("Web URL")
            Spacer()
        })
        .buttonStyle(NavigationLinkButtonStyle(showChevron: false))
    }
    
    var selectFileButton: some View {
        Button(action: {
            onAllowUserApps()
            dismiss()
        }, label: {
            Image(systemName: "folder")
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
            Text("Select from file")
            Spacer()
        })
        .buttonStyle(NavigationLinkButtonStyle(showChevron: false))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Apps")
                    .font(.headline)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 12)
                
                
                if (!hasUserApplicationsAccess) {
                    userAppsWarning
                        .padding(.bottom, 12)
                }
                
                VStack(spacing: 0) {
                    webUrlButton
                    
                    // TODO: maybe enable this for selecting individual .apps?
//                    Divider().padding(.horizontal, 12)
//                    selectFileButton

                    ForEach(apps.indices, id: \.self) { index in
                        Divider()
                            .padding(.horizontal, 12)
                        
                        let app = apps[index]
                        Button(action: {
                            onAppSelected(app)
                            dismiss()
                        }, label: {
                            if let icon = app.icon {
                                Image(nsImage: icon)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            Text(app.name)
                            Spacer()
                        })
                        .buttonStyle(NavigationLinkButtonStyle(showChevron: false))
                    }
                }
                .sectionStyle()
            }
            .padding(16)
        }
    }
}

#Preview {
    SelectAppSheet(
        apps: [],
        onAppSelected: { app in },
        onUrlSelected: {},
        onAllowUserApps: {},
        hasUserApplicationsAccess: false
    )
}
