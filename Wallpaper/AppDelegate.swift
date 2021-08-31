//
//  AppDelegate.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/25.
//

import Cocoa

// UserDefaults last record key
let kLastWallpaper = "kLastWallpaper"

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var model: WallpaperModel? {
        didSet {
            if oldValue != self.model {
                self.wallpaperWindowDict.forEach({
                    $0.value.reload(self.model)
                })
            }
        }
    }
    
    var preScreensHashValue: Int = 0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.createStatusMenuItem()
        self.reloadWallpaperWindows()
        
        self.reloadCache()
        
        /// - 监听screens 变化
        self.preScreensHashValue = NSScreen.screens.hashValue
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.afterWaiting.rawValue, true, 0) { _, _ in
            let hashValue = NSScreen.screens.hashValue
            if self.preScreensHashValue != hashValue {
                self.preScreensHashValue = hashValue
                self.reloadWallpaperWindows()
            }
        }
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, .commonModes)
        
        /// - 监听界面改变
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.activeSpaceDidChangeNotification, object: nil, queue: .main) { _ in
            self.wallpaperWindowDict.forEach({
                $0.value.orderFront(nil)
            })
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
    
    // MARK: - StatusItem
    var statusMenuItem: NSStatusItem!
    
    func createStatusMenuItem() {
        
        self.statusMenuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusMenuItem.button?.title = "Wallpaper"


        let menu = NSMenu()
        menu.addItem(.init(title: "本地网页", action: #selector(statusMenuItemClick(_:)), keyEquivalent: ""))
        menu.addItem(.init(title: "在线网页", action: #selector(statusMenuItemClick(_:)), keyEquivalent: ""))
        menu.addItem(.init(title: "视频", action: #selector(statusMenuItemClick(_:)), keyEquivalent: ""))
        menu.addItem(.init(title: "图片", action: #selector(statusMenuItemClick(_:)), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(.init(title: "退出", action: #selector(statusMenuItemClick(_:)), keyEquivalent: "q"))
        self.statusMenuItem.menu = menu
    }
    
    @objc func statusMenuItemClick(_ item: NSMenuItem) {
        
        if item.title == "在线网页" {
            let wc = TextInputWindowController.loadFromNib()
            wc.showWindow(nil)
            wc.confirmCallback = {
                if let url = URL(string: $0) {
                    self.model = WallpaperModel.init(type: .web, url: url)
                    self.writeCache()
                }
            }
            return
        }
        
        guard let url = pickFile() else {
            return
        }
        
        switch item.title {
        case "本地网页":
            self.model = WallpaperModel.init(type: .web, url: url)
            self.writeCache()
            
        case "视频":
            self.model = WallpaperModel.init(type: .video, url: url)
            self.writeCache()
            
        case "图片":
            self.model = WallpaperModel.init(type: .image, url: url)
            self.writeCache()
            
        case "退出":
            NSApp.terminate(nil)

        default:
            break
        }
    }
    
    
    // MARK: - WallpaperWindow
    var wallpaperWindowDict = [AnyHashable: WallpaperWindow]()
    
    func reloadWallpaperWindows() {
        
        var releaseDict = self.wallpaperWindowDict
        let screens = NSScreen.screens
        for screen in screens {
            releaseDict.removeValue(forKey: screen.hashValue)

            var window = self.wallpaperWindowDict[screen.hashValue]
            if window == nil {
                window = WallpaperWindow(contentRect: .init(x: 0, y: 0, width: screen.frame.width, height: screen.frame.height), screen: screen)
                window?.reload(self.model)
                window?.backgroundColor = .clear
                window?.orderFront(nil)

                self.wallpaperWindowDict[screen] = window
            }
        }

        for (key, _) in releaseDict {
            self.wallpaperWindowDict.removeValue(forKey: key)?.orderOut(nil)
        }
    }
    
    // MARK: - Cache
    func writeCache() {
        
        guard let model = self.model else {
            return
        }
        
        UserDefaults.standard.setValue(model.encode(), forKey: kLastWallpaper)
        UserDefaults.standard.synchronize()
    }
    
    func reloadCache() {
        
        if let dict = UserDefaults.standard.object(forKey: kLastWallpaper) as? [String: Any] {
            let model = WallpaperModel(dict: dict)
            self.model = model
        }
        
    }
}
