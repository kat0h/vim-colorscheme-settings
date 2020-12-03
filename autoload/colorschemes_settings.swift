// ============================================================================
// Filename: autoload/colorschemes_settings.swift
// Author: KotaKato
// License: MIT License
// ============================================================================
// reference : https://stackoverflow.com/questions/59277634/
import Foundation
import Cocoa

class ObserveColorMode {
    func observe() {
        DistributedNotificationCenter.default.addObserver(
            forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil,
            queue: nil,
            using: self.interfaceModeChanged
        )
    }
    func interfaceModeChanged(_ notification: Notification) {
        print(UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light")
    }
}

let app = NSApplication.shared
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let observer = ObserveColorMode.init()
        observer.observe()
    }
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()
