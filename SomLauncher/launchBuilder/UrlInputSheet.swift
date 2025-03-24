//
//  UrlInputSheet.swift
//  SomLauncher
//
//  Created by Magnus von Scheele on 2024-10-12.
//
import SwiftUI


struct UrlInputSheet: View {
    @Environment(\.dismiss) private var dismiss

    var onUrlSubmit: (String) -> Void

    @State private var urlInput: String = ""
    @State private var urlInputError: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("URL")
                .font(.headline)
                .padding(.bottom, 8)

            TextField("", text: $urlInput, prompt: Text("Required"))
                .textFieldStyle(.roundedBorder)
                .frame(minWidth: 280)
                .onChange(of: urlInput) {
                    withAnimation {
                        urlInputError = false
                    }
                }

            if (urlInputError) {
                Text("Invalid URL")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            
            Spacer(minLength: 16)
            
            VStack() {
                Button(action: {
                    let url = URL(string: urlInput)
                    if (url != nil) {
                        onUrlSubmit(urlInput)
                        dismiss()
                    } else {
                        // This won't happen often, decision for now is to let it slide.
                        // Instead of difficult validation that might end up blocking some user.
                        withAnimation {
                            urlInputError = true
                        }
                    }
                }) {
                    Text("Confirm")
                }
                .buttonStyle(.borderedProminent)
                .disabled(urlInput.count <= 0)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(16)
    }
}

#Preview {
    UrlInputSheet(onUrlSubmit: { url in })
}
