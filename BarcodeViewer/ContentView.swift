//
//  ContentView.swift
//  BarcodeViewer
//
//  Created by Philip Lin on 2026/4/27.
//

import SwiftUI

/// Main view: displays the current barcode full-width.
/// Swipe left/right to cycle. Toolbar for list and add.
///
/// Brightness: maxed when displaying a barcode with no sheets open
/// and the app is active. Restored to the user's original level otherwise.
struct ContentView: View {
    @Bindable var store: BarcodeStore
    @Environment(\.scenePhase) private var scenePhase

    @State private var showingAddSheet = false
    @State private var showingListSheet = false

    /// The user's brightness before we cranked it up.
    @State private var savedBrightness: CGFloat = UIScreen.main.brightness

    /// Whether we should be at max brightness right now.
    private var wantsMaxBrightness: Bool {
        store.currentItem != nil
        && !showingAddSheet
        && !showingListSheet
        && scenePhase == .active
    }

    var body: some View {
        NavigationStack {
            Group {
                if let item = store.currentItem {
                    barcodeDisplay(item: item)
                } else {
                    emptyState
                }
            }
            .navigationTitle("BarcodeViewer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingListSheet = true
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                    .disabled(store.items.isEmpty)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddBarcodeView(store: store)
            }
            .sheet(isPresented: $showingListSheet) {
                BarcodeListView(store: store)
            }
        }
        .onAppear { updateBrightness() }
        .onChange(of: scenePhase) { _, _ in updateBrightness() }
        .onChange(of: showingAddSheet) { _, _ in updateBrightness() }
        .onChange(of: showingListSheet) { _, _ in updateBrightness() }
        .onChange(of: store.currentItem?.id) { _, _ in updateBrightness() }
    }

    // MARK: - Brightness

    private func updateBrightness() {
        if wantsMaxBrightness {
            // Capture current brightness only if we haven't already maxed it,
            // so we don't accidentally save 1.0 as the "original" value.
            if UIScreen.main.brightness < 1.0 {
                savedBrightness = UIScreen.main.brightness
            }
            UIScreen.main.brightness = 1.0
        } else {
            UIScreen.main.brightness = savedBrightness
        }
    }

    // MARK: - Barcode Display

    @ViewBuilder
    private func barcodeDisplay(item: BarcodeItem) -> some View {
        VStack(spacing: 24) {
            Spacer()

            if let image = BarcodeGenerator.generate(
                text: item.text,
                codec: item.codec,
                size: CGSize(width: 600, height: item.codec == .qr ? 600 : 200)
            ) {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 24)
            }

            VStack(spacing: 6) {
                Text(item.text)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)

                Text(item.codec.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if store.items.count > 1 {
                    Text("\(store.currentIndex + 1) / \(store.items.count)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 50, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width < -50 {
                        withAnimation { store.next() }
                    } else if value.translation.width > 50 {
                        withAnimation { store.previous() }
                    }
                }
        )
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Barcodes", systemImage: "barcode.viewfinder")
        } description: {
            Text("Tap + to add your first barcode.")
        } actions: {
            Button("Add Barcode") {
                showingAddSheet = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
