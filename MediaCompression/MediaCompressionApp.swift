//
//  MediaCompressionApp.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI

@main
struct MediaCompressionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
