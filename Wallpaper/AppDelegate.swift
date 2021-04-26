//
//  AppDelegate.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/25.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let mainScreen = NSScreen.main!
        let kCGDesktopWindowLevel = -2147483623
        
        window = NSWindow(contentRect: mainScreen.frame, styleMask: [.borderless, .fullSizeContentView], backing: .buffered, defer: false)
        window.level = .init(kCGDesktopWindowLevel - 1)
        window.backgroundColor = .black
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        
        
        // -- StatusItem
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem.button?.title = "Wallpaper"
        
        
        let menu = NSMenu()
        menu.addItem(.init(title: "本地网页", action: #selector(menuItemClick(_:)), keyEquivalent: ""))
        menu.addItem(.init(title: "在线网页", action: #selector(menuItemClick(_:)), keyEquivalent: ""))
        menu.addItem(.init(title: "视频", action: #selector(menuItemClick(_:)), keyEquivalent: ""))
        menu.addItem(.init(title: "图片", action: #selector(menuItemClick(_:)), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(.init(title: "退出", action: #selector(menuItemClick(_:)), keyEquivalent: "q"))
        self.statusItem.menu = menu
    }

    
    @objc func menuItemClick(_ item: NSMenuItem) {
        switch item.title {
        case "本地网页":
            if let url = self.pickFile() {
                let c = WebContentView(frame: self.window.frame)
                c.loadUrl(url)
                self.window.contentView = c
            }
            
        case "在线网页":
            if let str = AppleScript.inputUrl(),
               let url = URL.init(string: str) {
                guard url.scheme != nil else {
                    return
                }
                
                let c = WebContentView(frame: self.window.frame)
                c.loadUrl(url)
                self.window.contentView = c
            }
            
        case "视频":
            if let url = self.pickFile() {
                let c = VideoContentView(frame: self.window.frame)
                c.loadUrl(url)
                self.window.contentView = c
            }
        case "图片":
            if let url = self.pickFile() {
                let c = ImageContentView(frame: self.window.frame)
                c.loadUrl(url)
                self.window.contentView = c
            }
        case "退出":
            NSApp.terminate(nil)
        default:
            break
        }
    }
    
    
    func pickFile() -> URL? {
        let op = NSOpenPanel()
        op.canChooseFiles = true
        op.canChooseDirectories = false
        if op.runModal() == .OK {
            return op.urls.first
        }
        return nil
    }
    
}

