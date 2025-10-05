//
//  LaunchBuilderView.swift
//  SomLauncher
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
            GeometryReader { geo in
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                        TextField("", text: $nameInput, prompt: Text("Required"))
                            .controlSize(.large)
                            .padding(.horizontal, 20)
                        
                        Text("Build your custom launching script by adding Apps or URLs to the list. These will all be opened when the launcher is run.")
                            .font(.subheadline)
                            .padding(.top, 16)
                            .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach($actions) { $action in
                                CreateLaunchItemView(
                                    launchURL: $action.url,
                                    onDelete: { actions.remove(at: actions.firstIndex(of: action)!) })
                            }
                            
                            Button(action: {
                                actions.append(LaunchAction(url: nil))
                            }) {
                                Image(systemName: "plus.circle")
                                    .frame(width: 24, height: 24)
                                Text("Add item")
                            }
                            .buttonStyle(NavigationLinkButtonStyle())
                            .cornerRadius(8)
                        }
                        .animation(.easeInOut, value: actions)
                        .padding(.horizontal, 12)

                        Spacer(minLength: 0)
                        
                        HStack {
                            Button(action: {
                                showLaunchConfirmation.toggle()
                            }, label: {
                                Text("Run launcher")
                            })
                            .disabled(actions.isEmpty)
                            .buttonStyle(.bordered)
                            .controlSize(.large)
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
                            
                            
                            Button(action: {
                                let items = actions.compactMap({ action in
                                    if let url = action.url {
                                        LauncherScript.Item(url: url)
                                    } else {
                                        nil
                                    }
                                })
                                
                                if let script = selectedLauncher {
                                    script.name = nameInput
                                    script.items = items
                                    do {
                                        try script.modelContext?.save()
                                    } catch {
                                        print("Error saving script")
                                        modelContext.insert(script)
                                    }
                                } else {
                                    let script = LauncherScript(name: nameInput, items: items)
                                    modelContext.insert(script)
                                }
                                
                                withAnimation { showSuccess.toggle() }
                            }, label: { Text("Save launcher") })
                            .buttonStyle(.borderedProminent)
                            .disabled(actions
                                .filter({ action in action.url != nil })
                                .count == 0
                                      || nameInput.count <= 0
                            )
                            .controlSize(.large)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geo.size.height, alignment: .top)
                }
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
        .navigationTitle("\(selectedLauncher == nil ? "Build" : "Edit") your launcher")
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
                    onDismiss()
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
