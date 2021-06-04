//
//  spotibarApp.swift
//  spotibar
//
//  Created by Marcus Nilszén on 2020-12-28.
//

import SwiftUI
import ScriptingBridge

var isTurnedOn = true

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
        let title = NSMenuItem()
        title.title = "Spotibar"
        
        let toggle = NSMenuItem()
        toggle.title = "Is turned on"
        toggle.action = #selector(handleToggle(_:))
        toggle.state = NSControl.StateValue.on
        
        let menu = NSMenu()
        menu.items = [
            title,
            NSMenuItem.separator(),
            toggle,
            NSMenuItem(title: "Check for updates...", action: #selector(handleCheckVersion(_:)), keyEquivalent: ""),
            NSMenuItem(title: "Go to my github!", action: #selector(handleGithub(_:)), keyEquivalent: ""),
//            NSMenuItem(title: "Preferences", action: #selector(NSApp.), keyEquivalent: ","),
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
        if isTurnedOn {
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
        }
        
        return false
    }
    
    @IBAction func handleToggle(_ sender: NSMenuItem) {
        isTurnedOn = !isTurnedOn
        
        if isTurnedOn {
            sender.state = NSControl.StateValue.on
        } else {
            sender.state = NSControl.StateValue.off
        }
    }
    
    @objc func handleCheckVersion(_ sender: NSMenuItem) {
        let url = URL(string: "https://github.com/mebn/spotibar/releases/latest")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func handleGithub(_ sender: NSMenuItem) {
        let url = URL(string: "https://github.com/mebn/")!
        NSWorkspace.shared.open(url)
    }
}
