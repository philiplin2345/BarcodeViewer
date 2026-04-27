//
//  BarcodeGenerator.swift
//  BarcodeViewer
//
//  Created by Philip Lin on 2026/4/27.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

/// Generates barcode UIImages from text using Core Image or manual rendering.
enum BarcodeGenerator {

    /// Generate a barcode image for the given text and codec.
    /// Returns `nil` if the text is empty or cannot be encoded.
    static func generate(text: String, codec: BarcodeCodec, size: CGSize = CGSize(width: 600, height: 200)) -> UIImage? {
        guard !text.isEmpty else { return nil }

        switch codec {
        case .code128:
            return generateCIBarcode(text: text, filterName: "CICode128BarcodeGenerator", size: size)
        case .qr:
            return generateCIBarcode(text: text, filterName: "CIQRCodeGenerator", size: CGSize(width: size.height, height: size.height))
        case .code39:
            return generateCode39(text: text, size: size)
        }
    }

    // MARK: - Core Image Based

    private static func generateCIBarcode(text: String, filterName: String, size: CGSize) -> UIImage? {
        guard let data = text.data(using: .ascii) else { return nil }
        guard let filter = CIFilter(name: filterName) else { return nil }

        filter.setValue(data, forKey: "inputMessage")

        guard let outputImage = filter.outputImage else { return nil }

        // Scale to desired size
        let scaleX = size.width / outputImage.extent.width
        let scaleY = size.height / outputImage.extent.height
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }

    // MARK: - Code 39 Manual Rendering

    /// Code 39 character-to-pattern mapping.
    /// Each pattern string is 9 characters: 'n' = narrow, 'w' = wide.
    /// Alternating bar/space starting with bar.
    private static let code39Table: [Character: String] = [
        "0": "nnnwwnwnn", "1": "wnnwnnnnw", "2": "nnwwnnnnw",
        "3": "wnwwnnnnn", "4": "nnnwwnnnw", "5": "wnnwwnnnn",
        "6": "nnwwwnnnn", "7": "nnnwnnwnw", "8": "wnnwnnwnn",
        "9": "nnwwnnwnn", "A": "wnnnnwnnw", "B": "nnwnnwnnw",
        "C": "wnwnnwnnn", "D": "nnnnwwnnw", "E": "wnnnwwnnn",
        "F": "nnwnwwnnn", "G": "nnnnnwwnw", "H": "wnnnnwwnn",
        "I": "nnwnnwwnn", "J": "nnnnwwwnn", "K": "wnnnnnnww",
        "L": "nnwnnnnww", "M": "wnwnnnnwn", "N": "nnnnwnnww",
        "O": "wnnnwnnwn", "P": "nnwnwnnwn", "Q": "nnnnnnwww",
        "R": "wnnnnnwwn", "S": "nnwnnnwwn", "T": "nnnnwnwwn",
        "U": "wwnnnnnnw", "V": "nwwnnnnnw", "W": "wwwnnnnnn",
        "X": "nwnnwnnnw", "Y": "wwnnwnnnn", "Z": "nwwnwnnnn",
        "-": "nwnnnnwnw", ".": "wwnnnnwnn", " ": "nwwnnnwnn",
        "$": "nwnwnwnnn", "/": "nwnwnnnwn", "+": "nwnnnwnwn",
        "%": "nnnwnwnwn", "*": "nwnnwnwnn",
    ]

    private static func generateCode39(text: String, size: CGSize) -> UIImage? {
        // Code 39 must be wrapped in start/stop characters (*)
        let encoded = "*" + text.uppercased() + "*"

        // Validate all characters are in the table
        for char in encoded {
            guard code39Table[char] != nil else { return nil }
        }

        // Build the full bar pattern
        // narrow = 1 unit, wide = 3 units, inter-character gap = 1 unit
        var totalUnits = 0
        for (i, char) in encoded.enumerated() {
            let pattern = code39Table[char]!
            for c in pattern {
                totalUnits += (c == "w" ? 3 : 1)
            }
            if i < encoded.count - 1 {
                totalUnits += 1 // inter-character gap
            }
        }

        let unitWidth = size.width / CGFloat(totalUnits)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.fill(CGRect(origin: .zero, size: size))

            var x: CGFloat = 0
            for (i, char) in encoded.enumerated() {
                let pattern = code39Table[char]!
                for (j, p) in pattern.enumerated() {
                    let width = (p == "w" ? 3 : 1) * unitWidth
                    let isBar = j % 2 == 0  // even indices are bars
                    if isBar {
                        ctx.cgContext.setFillColor(UIColor.black.cgColor)
                        ctx.cgContext.fill(CGRect(x: x, y: 0, width: width, height: size.height))
                    }
                    x += width
                }
                // Inter-character gap (space)
                if i < encoded.count - 1 {
                    x += unitWidth
                }
            }
        }
    }
}
