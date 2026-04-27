//
//  BarcodeStore.swift
//  BarcodeViewer
//
//  Created by Philip Lin on 2026/4/27.
//

import Foundation

/// Manages persistence of barcode items and the currently-displayed index
/// using UserDefaults.
@Observable
final class BarcodeStore {

    // MARK: - Published State

    private(set) var items: [BarcodeItem] = []
    var currentIndex: Int = 0

    // MARK: - UserDefaults Keys

    private static let itemsKey = "BarcodeStore.items"
    private static let indexKey = "BarcodeStore.currentIndex"

    // MARK: - Init

    init() {
        load()
    }

    // MARK: - Public API

    /// Add a new barcode and make it the current one.
    func add(text: String, codec: BarcodeCodec) {
        let item = BarcodeItem(text: text, codec: codec)
        items.append(item)
        currentIndex = items.count - 1
        save()
    }

    /// Delete a barcode by ID.
    func delete(id: UUID) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        items.remove(at: idx)

        // Adjust currentIndex so it stays in bounds.
        if items.isEmpty {
            currentIndex = 0
        } else if currentIndex >= items.count {
            currentIndex = items.count - 1
        }
        save()
    }

    /// Set the currently-displayed barcode by ID.
    func setCurrent(id: UUID) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        currentIndex = idx
        save()
    }

    /// The barcode that should currently be displayed, if any.
    var currentItem: BarcodeItem? {
        guard !items.isEmpty, currentIndex >= 0, currentIndex < items.count else {
            return nil
        }
        return items[currentIndex]
    }

    /// Move to the next barcode (wraps around).
    func next() {
        guard items.count > 1 else { return }
        currentIndex = (currentIndex + 1) % items.count
        save()
    }

    /// Move to the previous barcode (wraps around).
    func previous() {
        guard items.count > 1 else { return }
        currentIndex = (currentIndex - 1 + items.count) % items.count
        save()
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: Self.itemsKey)
        }
        UserDefaults.standard.set(currentIndex, forKey: Self.indexKey)
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: Self.itemsKey),
           let decoded = try? JSONDecoder().decode([BarcodeItem].self, from: data) {
            items = decoded
        }
        currentIndex = UserDefaults.standard.integer(forKey: Self.indexKey)

        // Clamp to valid range.
        if currentIndex >= items.count {
            currentIndex = max(0, items.count - 1)
        }
    }
}
