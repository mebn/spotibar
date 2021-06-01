//
//  spotibarApp.swift
//  spotibar
//
//  Created by Marcus Nilszén on 2020-12-28.
//

import SwiftUI
import ScriptingBridge

@main
struct spotibarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, MediaKeysDelegate {
    var statusBarItem: NSStatusItem?
    var mediaKeys: MediaKeys!
    let spotify = SBApplication(bundleIdentifier: "com.spotify.client")! as SpotifyApplication
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        handleMenuBar()
        listenForMediaKeys()
    }
    
    func handleMenuBar() {
        if spotify.playerState == .playing {
            
        }
//        let view = NSHostingView(rootView: ContentView())
//        view.frame = NSRect(x: 0, y: 0, width: 250, height: 240)
//        let menuItem = NSMenuItem()
//        menuItem.view = view
        
        let title = NSMenuItem()
        title.title = "Spotibar 🔊"
        
        let menu = NSMenu()
        menu.items = [
            title,
            NSMenuItem(title: "Visit my github 🧑‍💻", action: #selector(handleOpenUpdateWindow(_:)), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Quit 👋", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"),
        ]
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.image = NSImage(named: "logoTemplate")
        statusBarItem?.menu = menu
    }
    
    func listenForMediaKeys() {
        mediaKeys = MediaKeys(delegate: self)
    }
    
    func mediaKeys(_ mediaKeys: MediaKeys, shouldInterceptKeyWithKeyCode keyCode: Int32) -> Bool {
        switch keyCode {
            case NX_KEYTYPE_PLAY:
                spotify.playpause?()
                return true
            case NX_KEYTYPE_FAST:
                spotify.nextTrack?()
                return true
            case NX_KEYTYPE_REWIND:
                spotify.previousTrack?()
                return true
            default:
                break
        }
        return false
    }
    
    @objc func handleOpenUpdateWindow(_ sender: NSMenuItem) {
        let url = URL(string: "https://github.com/mebn/spotibar")!
        NSWorkspace.shared.open(url)
    }
}
