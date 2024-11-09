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
    var onFileSelected: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Apps")
                    .font(.headline)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 12)
                
                VStack(spacing: 0) {
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

                    Divider()
                        .padding(.horizontal, 12)
                    
                    Button(action: {
                        onFileSelected()
                        dismiss()
                    }, label: {
                        Image(systemName: "folder")
                            .font(.system(size: 20))
                            .frame(width: 24, height: 24)
                        Text("Select from file")
                        Spacer()
                    })
                    .buttonStyle(NavigationLinkButtonStyle(showChevron: false))

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
