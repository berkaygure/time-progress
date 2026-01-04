//
//  time_progressApp.swift
//  time-progress
//
//  Created by Berkay Güre on 4.01.2026.
//

import SwiftUI

@main
struct time_progressApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Settings window (can be opened from menu)
        Settings {
            SettingsView()
        }
    }
}
