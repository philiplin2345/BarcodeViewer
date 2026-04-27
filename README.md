# BarcodeViewer

> [!IMPORTANT]
> **Perfect for Taiwan Invoice Carriers (電子發票載具)**  
> This app is an excellent utility for users in Taiwan to store and quickly display their E-Invoice Carrier (載具) barcodes. By keeping your carrier barcode just a swipe away with automatic max-brightness, you can ensure a seamless scanning experience at any checkout counter.

BarcodeViewer is a minimalist, high-performance iOS application designed for the singular purpose of storing and displaying barcodes and QR codes with zero friction.

## Features

- **One-View Focus**: Displays exactly one barcode at a time for maximum clarity.
- **Smart Brightness Control**: Automatically cranks screen brightness to 100% when a barcode is displayed to ensure scanner readability, and restores your previous setting when you leave the app or open a menu.
- **Multiple Formats**: Supports **Code 128**, **Code 39**, and **QR Codes**.
- **Intuitive Navigation**: Swipe left or right to cycle through your stored barcodes.
- **Zero Cloud Dependency**: All data is stored locally on your device using `UserDefaults`.
- **Live Preview**: See your barcode generate in real-time as you type the raw text.

## Usage

1. **Add**: Tap the `+` icon to add a new barcode. Enter your raw text (e.g., your `/ABC1234` carrier string) and choose the appropriate format (usually Code 128 for Taiwan carriers).
2. **View**: The main screen displays your current barcode.
3. **Switch**: Swipe horizontally to switch between multiple barcodes (e.g., membership cards, library cards, and carriers).
4. **Manage**: Tap the list icon to see all saved barcodes, reorder them, or delete old ones.

## Technical Details

- **Language**: Swift 5.10+
- **Framework**: SwiftUI
- **Architecture**: MVVM-style with `@Observable` for state management.
- **Rendering**: Uses `CoreImage` (`CIFilter`) for Code 128 and QR generation. Implements a custom rendering engine for Code 39 to ensure high-contrast, pixel-perfect bars.
- **Persistence**: JSON encoding via `Codable` stored in `UserDefaults`.

## Requirements

- iOS 17.0+
- Xcode 15.0+

## License

This project is open-source and available under the MIT License.
