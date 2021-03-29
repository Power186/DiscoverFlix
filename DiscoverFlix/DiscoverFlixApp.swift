//
//  DiscoverFlixApp.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import SwiftUI

@main
struct DiscoverFlixApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init() {
        let temporaryDirectory = NSTemporaryDirectory()
                let urlCache = URLCache(memoryCapacity: 250_000_000, diskCapacity: 300_000_000, diskPath: temporaryDirectory)
                URLCache.shared = urlCache
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.colorScheme, isDarkMode ? .dark : .light)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
