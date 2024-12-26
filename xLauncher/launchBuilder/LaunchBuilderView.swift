//
//  LaunchBuilderView.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-13.
//
import SwiftUI
import SwiftData

struct LaunchBuilderView: View {
    @Binding var selectedLauncher: LauncherScript?

    @State private var nameInput: String = ""
    @State private var actions: [LaunchAction] = []

    @Environment(\.modelContext) private var modelContext
    
    @State private var showLaunchConfirmation = false
    @State private var showSuccess = false
    @State private var showDeleteConfirmation = false
    
    init(selectedLauncher: Binding<LauncherScript?>) {
        _selectedLauncher = selectedLauncher
        _nameInput = State(initialValue: selectedLauncher.wrappedValue?.name ?? "")
        _actions = State(initialValue: selectedLauncher.wrappedValue?.items.map({
            LaunchAction(id: $0.id, url: $0.url)
        }) ?? [])
    }
    
    var body: some View {
        return ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(selectedLauncher == nil ? "Build" : "Edit") your launcher")
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
                            actions.append(LaunchAction(url: nil))
                        }) {
                            Image(systemName: "plus.circle")
                                .padding(2)
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
                        Label("Test launch", systemImage: "chevron.right")
                            .labelStyle(ReversedLabelStyle())
                    })
                    .disabled(actions.isEmpty)
                    .padding(.horizontal, 12)
                    .buttonStyle(.plain)
                    .confirmationDialog(
                        "Launch all your actions?",
                        isPresented: $showLaunchConfirmation
                    ) {
                        Button("Launch") {
                            actions.forEach { action in
                                AppLauncher.openAction(action: action)
                            }
                        }
                    }
                    
                    
                    Spacer(minLength: 32)
                    Text("Name")
                        .font(.subheadline)
                    TextField("", text: $nameInput, prompt: Text("Required"))
                        .textFieldStyle(.roundedBorder)
                        .controlSize(.large)
                    
                    Spacer(minLength: 8)
                    
                    Button(action: {
                        let items = actions.compactMap({ action in
                            if let url = action.url {
                                LauncherScript.Item(url: url)
                            } else {
                                nil
                            }
                        })
                        
                        let script = LauncherScript(name: nameInput, items: items)
                        modelContext.insert(script)
                        withAnimation { showSuccess.toggle() }
                    }, label: { Text("Save") }).buttonStyle(.borderedProminent)
                        .disabled(nameInput.count <= 0)
                        .controlSize(.large)
                }.padding()
            }
            if (showSuccess) {
                SuccessView(launcherName: nameInput, onDismiss: { showSuccess.toggle() })
            }
        }
        .toolbar {
            Spacer()
            if let script = selectedLauncher {
                Button(action: {
                    showDeleteConfirmation.toggle()
                }, label: { Label("Delete", systemImage: "trash") })
                .confirmationDialog(
                    Text("Delete launcher?"),
                    isPresented: $showDeleteConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        withAnimation {
                            selectedLauncher = nil
                            modelContext.delete(script)
                        }
                    }
                }
            }
        }
        .onChange(of: selectedLauncher, {
            nameInput = selectedLauncher?.name ?? ""
            actions = selectedLauncher?.items.map({
                LaunchAction(id: $0.id, url: $0.url)
            }) ?? []
        })
    }
}

struct SuccessView: View {
    var launcherName: String
    var onDismiss: () -> Void
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .frame(width: 48, height: 48)
                .foregroundStyle(.green)
            Text("\"\(launcherName)\" saved")
            
            Spacer()
            
            HStack {
                Button("Back to edit") {
                    onDismiss()
                }
                Button("Close window") {
                    dismissWindow()
                }.buttonStyle(.borderedProminent)
            }.padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
    }
}

#Preview {
    SuccessView(launcherName: "Test", onDismiss: {})
}

#Preview {
    LaunchBuilderView(selectedLauncher: .constant(nil))
}
