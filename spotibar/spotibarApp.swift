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
    var popover = NSPopover()
    var statusBarItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let view = NSHostingView(rootView: ContentView())
        view.frame = NSRect(x: 0, y: 0, width: 300, height: 500)
        let menuItem = NSMenuItem()
        menuItem.view = view
        let menu = NSMenu()
        menu.addItem(menuItem)
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.title = "SpotiBar"
        statusBarItem?.menu = menu
    }
}
