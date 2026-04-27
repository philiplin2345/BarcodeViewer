# 📱 BarcodeViewer

> [!IMPORTANT]
> 🇹🇼 **Perfect for Taiwan Invoice Carriers (電子發票載具)**  
> This app is an excellent utility for users in Taiwan to store and quickly display their E-Invoice Carrier (載具) barcodes. By keeping your carrier barcode just a swipe away with automatic max-brightness, you can ensure a seamless scanning experience at any checkout counter. 🧾✨

BarcodeViewer is a minimalist, high-performance iOS application designed for the singular purpose of storing and displaying barcodes and QR codes with zero friction.

---

## ✨ Features

| | Feature | Description |
|---|---|---|
| 🔍 | **One-View Focus** | Displays exactly one barcode at a time for maximum clarity. |
| 🔆 | **Smart Brightness** | Auto-maxes screen brightness when viewing a barcode; restores it when you leave. |
| 🏷️ | **Multiple Formats** | Supports **Code 128**, **Code 39**, and **QR Codes**. |
| 👆 | **Swipe Navigation** | Swipe left or right to cycle through your stored barcodes. |
| 🔒 | **Fully Offline** | All data is stored locally on your device — zero cloud dependency. |
| 👀 | **Live Preview** | See your barcode generate in real-time as you type. |

---

## 🚀 Usage

1. ➕ **Add** — Tap the `+` icon to add a new barcode. Enter your raw text (e.g., your `/ABC1234` carrier string) and choose the appropriate format (usually Code 128 for Taiwan carriers).
2. 📸 **View** — The main screen displays your current barcode at full brightness.
3. 👈👉 **Switch** — Swipe horizontally to switch between multiple barcodes (e.g., membership cards, library cards, and carriers).
4. 📋 **Manage** — Tap the list icon to see all saved barcodes, select them, or swipe to delete.

---

## 🛠️ Technical Details

| | | |
|---|---|---|
| 🐦 | **Language** | Swift 5.10+ |
| 🖼️ | **Framework** | SwiftUI |
| 🏗️ | **Architecture** | MVVM-style with `@Observable` for state management |
| ⚙️ | **Rendering** | `CoreImage` (`CIFilter`) for Code 128 & QR; custom engine for Code 39 |
| 💾 | **Persistence** | JSON encoding via `Codable` stored in `UserDefaults` |

---

## 📋 Requirements

| | |
|---|---|
| 📱 iOS | 17.0+ |
| 🔨 Xcode | 15.0+ |

---

## 📄 License

This project is open-source and available under the **MIT License**.
