//
//  SelectAppSheet.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-06.
//
import SwiftUI
import AppKit

struct SelectAppSheet: View {
    @Environment(\.dismiss) private var dismiss

    var apps : [InstalledApp]
    var onAppSelected: (InstalledApp) -> Void
    var onUrlSelected: () -> Void
    var onAllowUserApps: () -> Void
    var hasUserApplicationsAccess: Bool
    
    @State private var searchText: String = ""
    
    private var filteredApps: [InstalledApp] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return apps }
        let foldedQuery = query.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        return apps.filter { app in
            app.name.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                .contains(foldedQuery)
        }
    }
    
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
        NavigationLink(value: "") {
            Image(systemName: "network")
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
            Text("Web URL")
        }
        .simultaneousGesture(TapGesture().onEnded {
            onUrlSelected()
            dismiss()
        })
    }
    
    var selectFileButton: some View {
        NavigationLink(value: "") {
            Image(systemName: "folder")
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
            Text("Select from file")
        }
        .simultaneousGesture(TapGesture().onEnded {
            onAllowUserApps()
            dismiss()
        })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 12) {
                        Text("Select app").font(.headline)
                        Spacer()
                        SearchFieldRepresentable(text: $searchText)
                            .frame(width: 240)
                    }
                    
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    
                    if (!hasUserApplicationsAccess) {
                        userAppsWarning
                            .padding(.top, 16)
                            .padding(.horizontal, 20)
                    }
                    
                    Form {
                        webUrlButton
                        
                        // TODO: maybe enable this for selecting individual .apps?
                        // selectFileButton
                        
                        ForEach(filteredApps.indices, id: \.self) { index in
                            let app = filteredApps[index]
                            NavigationLink(value: "") {
                                if let icon = app.icon {
                                    Image(nsImage: icon)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                                Text(app.name)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                onAppSelected(app)
                                dismiss()
                            })
                        }
                    }
                    .formStyle(.grouped)
                }
            }
        }
    }
}

struct SearchFieldRepresentable: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String = "Search"

    func makeCoordinator() -> Coordinator { Coordinator(text: $text) }

    func makeNSView(context: Context) -> NSSearchField {
        let f = NSSearchField()
        f.placeholderString = placeholder
        f.delegate = context.coordinator
        return f
    }

    func updateNSView(_ nsView: NSSearchField, context: Context) {
        if nsView.stringValue != text { nsView.stringValue = text }
    }

    final class Coordinator: NSObject, NSSearchFieldDelegate {
        var text: Binding<String>
        init(text: Binding<String>) { self.text = text }
        func controlTextDidChange(_ obj: Notification) {
            guard let f = obj.object as? NSSearchField else { return }
            text.wrappedValue = f.stringValue
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
