//
//  AppDelegate.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/25.
//

import Cocoa

enum WallpaperType: Int {
    case web = 0
    case image
    case video
}

// UserDefaults last record key
let kLastWallpaper = "kLastWallpaper"


class Window: NSWindow {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
    
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let mainScreen = NSScreen.main!
        let kCGDesktopWindowLevel = -2147483623
        
        window = Window(contentRect: mainScreen.frame, styleMask: [.borderless, .fullSizeContentView], backing: .buffered, defer: false)
        window.level = .init(kCGDesktopWindowLevel - 1)
        window.backgroundColor = .black
        window.hasShadow = false
        window.isReleasedWhenClosed = false
        window.ignoresMouseEvents = true
        window.orderFront(nil)
        
        /// - 切换桌面时保持window也跟着切换
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.window.orderedIndex != 1 {
                self.window.orderFront(nil)
            }
        }
        
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
        
        // -- read last record wallpaper
        if let obj = UserDefaults.standard.object(forKey: kLastWallpaper) as? [String: Any] {
            guard let typeIdx = obj["type"] as? Int,
                  let type = WallpaperType(rawValue: typeIdx),
                  let urlstr = obj["url"] as? String,
                  let url = URL(string: urlstr) else {
                return
            }
            self.setWallpaper(url: url, type: type)
        }
    }

    
    @objc func menuItemClick(_ item: NSMenuItem) {
        switch item.title {
        case "本地网页":
            self.setWallpaper(url: self.pickFile(), type: .web)
            
        case "在线网页":
            let wc = TextInputWindowController.loadFromNib()
            wc.showWindow(nil)
            wc.confirmCallback = {
                if let url = URL(string: $0) {
                    self.setWallpaper(url: url, type: .web)
                }
            }

            
        case "视频":
            self.setWallpaper(url: self.pickFile(), type: .video)
            
        case "图片":
            self.setWallpaper(url: self.pickFile(), type: .image)

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
    
    func setWallpaper(url: URL?, type: WallpaperType) {
        guard let url = url else {
            return
        }
        
        var contentView: ContentView!
        switch type {
        case .web:
            contentView = WebContentView(frame: self.window.frame)
        case .video:
            contentView = VideoContentView(frame: self.window.frame)
        case .image:
            contentView = ImageContentView(frame: self.window.frame)
        }
        contentView.loadUrl(url)
        self.window.contentView = contentView
        
        // - save record
        UserDefaults.standard.setValue(["url": url.absoluteString, "type": type.rawValue], forKey: kLastWallpaper)
        UserDefaults.standard.synchronize()
    }
    
}

