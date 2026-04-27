//
//  BarcodeListView.swift
//  BarcodeViewer
//
//  Created by Philip Lin on 2026/4/27.
//

import SwiftUI

/// List of all saved barcodes. Tap to select, swipe to delete.
struct BarcodeListView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: BarcodeStore

    var body: some View {
        NavigationStack {
            Group {
                if store.items.isEmpty {
                    ContentUnavailableView(
                        "No Barcodes",
                        systemImage: "barcode",
                        description: Text("Add a barcode to get started.")
                    )
                } else {
                    List {
                        ForEach(store.items) { item in
                            Button {
                                store.setCurrent(id: item.id)
                                dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.text)
                                            .font(.body)
                                            .lineLimit(1)
                                        Text(item.codec.rawValue)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    if item.id == store.currentItem?.id {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.tint)
                                    }
                                }
                            }
                            .tint(.primary)
                        }
                        .onDelete { offsets in
                            for offset in offsets {
                                store.delete(id: store.items[offset].id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Barcodes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
