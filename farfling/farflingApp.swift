//
//  farflingApp.swift
//  farfling
//
//  Created by Richard Ollen Broadwell IV on 7/31/25.
//

import SwiftUI

@main
struct farflingApp: App {
    init() {
        UIView.appearance().overrideUserInterfaceStyle = .dark
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
