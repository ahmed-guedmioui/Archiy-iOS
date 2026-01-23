//
//  ArchiyApp.swift
//  Archiy
//
//  Created by Ahmed Guedmioui on 2/1/2026.
//

import SwiftUI

@main
struct ArchiyApp: App {
    
    init() {
        startDI()
    }
    
    var body: some Scene {
        WindowGroup {
            Navigation()
                .injectDependencies()
        }
    }
}
