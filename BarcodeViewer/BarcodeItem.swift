//
//  BarcodeItem.swift
//  BarcodeViewer
//
//  Created by Philip Lin on 2026/4/27.
//

import Foundation

/// The barcode encoding format.
enum BarcodeCodec: String, Codable, CaseIterable, Identifiable {
    case code128 = "Code 128"
    case code39  = "Code 39"
    case qr      = "QR"

    var id: String { rawValue }
}

/// A single stored barcode entry.
struct BarcodeItem: Codable, Identifiable {
    let id: UUID
    let text: String
    let codec: BarcodeCodec
    let createdAt: Date

    init(text: String, codec: BarcodeCodec) {
        self.id = UUID()
        self.text = text
        self.codec = codec
        self.createdAt = Date()
    }
}
