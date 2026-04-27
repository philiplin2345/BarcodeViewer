//
//  BarcodeViewerApp.swift
//  BarcodeViewer
//
//  Created by Philip Lin on 2026/4/27.
//

import SwiftUI

@main
struct BarcodeViewerApp: App {
    @State private var store = BarcodeStore()

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
