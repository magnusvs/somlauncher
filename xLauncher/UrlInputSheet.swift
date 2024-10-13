//
//  UrlInputSheet.swift
//  xLauncher
//
//  Created by Magnus von Scheele on 2024-10-12.
//
import SwiftUI


struct UrlInputSheet: View {
    @Environment(\.dismiss) private var dismiss

    var onUrlSubmit: (String) -> Void

    @State private var urlInput: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("URL")
                .font(.headline)
                .padding(.bottom, 8)

            TextField("", text: $urlInput, prompt: Text("Required"))
                .textFieldStyle(.roundedBorder)
                .frame(minWidth: 280)
            
            Spacer(minLength: 16)
            
            VStack() {
                Button(action: {
                    // TODO input validation
                    onUrlSubmit(urlInput)
                    dismiss()
                }, label: { Text("Confirm") })
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
