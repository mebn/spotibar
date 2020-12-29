//
//  spotibarApp.swift
//  spotibar
//
//  Created by Marcus Nilszén on 2020-12-28.
//

import SwiftUI

@main
struct spotibarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let view = NSHostingView(rootView: ContentView())
        view.frame = NSRect(x: 0, y: 0, width: 250, height: 240)
        let menuItem = NSMenuItem()
        menuItem.view = view
        let menu = NSMenu()
        menu.addItem(menuItem)
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.image = NSImage(systemSymbolName: "playpause.fill", accessibilityDescription: "")
        statusBarItem?.menu = menu
    }
}
