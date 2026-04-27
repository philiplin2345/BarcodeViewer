//
//  AddBarcodeView.swift
//  BarcodeViewer
//
//  Created by Philip Lin on 2026/4/27.
//

import SwiftUI

/// Sheet for adding a new barcode: text input, codec picker, and live preview.
struct AddBarcodeView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: BarcodeStore

    @State private var text = ""
    @State private var codec: BarcodeCodec = .code128

    var body: some View {
        NavigationStack {
            Form {
                Section("Barcode Text") {
                    TextField("Enter text…", text: $text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section("Codec") {
                    Picker("Format", selection: $codec) {
                        ForEach(BarcodeCodec.allCases) { c in
                            Text(c.rawValue).tag(c)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Preview") {
                    if let image = BarcodeGenerator.generate(
                        text: text,
                        codec: codec,
                        size: CGSize(width: 600, height: codec == .qr ? 600 : 200)
                    ) {
                        Image(uiImage: image)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .frame(maxWidth: .infinity)
                    } else if text.isEmpty {
                        Text("Type something to see a preview")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                    } else {
                        Text("Cannot encode this text as \(codec.rawValue)")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                    }
                }
            }
            .navigationTitle("Add Barcode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.add(text: text, codec: codec)
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
    }
}
