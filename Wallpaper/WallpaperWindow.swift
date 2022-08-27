//
//  WallpaperWindow.swift
//  Wallpaper
//
//  Created by Plumk on 2021/8/30.
//

import Cocoa

class WallpaperWindow: NSWindow {
    
    private var statusBarWindow: StatusBarWindow!
    
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
    
    convenience init(contentRect: NSRect, screen: NSScreen) {
        self.init(contentRect: contentRect, styleMask: [.borderless, .fullSizeContentView], backing: .buffered, defer: false, screen: screen)
        self.statusBarWindow = StatusBarWindow(screen: screen)
        self.setup()
    }
    
    private func setup() {
        
        self.level = .init(Int(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)))
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        self.hasShadow = false
        self.isReleasedWhenClosed = false
        self.ignoresMouseEvents = true
        
        if let array = CGWindowListCopyWindowInfo([], 0) as? [[String: Any]] {
            /// 桌面点击响应的window
            let infos = array.filter({
                $0["kCGWindowLayer"] as? Int == -2147483603
            })
            infos.forEach({
                if let wn = $0["kCGWindowNumber"] as? Int {
                    App.desktopHandleWindowNumbers.insert(wn)
                }
            })
        }
    }
    
    override func orderFront(_ sender: Any?) {
        super.orderFront(sender)
        self.statusBarWindow.orderFront(sender)
    }
    
    override func orderBack(_ sender: Any?) {
        super.orderBack(sender)
        self.statusBarWindow.orderBack(sender)
    }
    
    override func orderOut(_ sender: Any?) {
        super.orderOut(sender)
        self.statusBarWindow.orderOut(sender)
    }
    
    deinit {
        print("deinit", self)
    }

    func reload(_ model: WallpaperModel?) {
        guard let model = model else {
            return
        }
        
        var contentView: ContentView!
        switch model.type {
        case .web:
            contentView = WebContentView()
            
        case .image:
            contentView = ImageContentView()
            
        case .video:
            contentView = VideoContentView()
            
        }
        contentView.loadUrl(model.url)
        self.contentView?.removeFromSuperview()
        self.contentView = contentView
    }

    
    override func update() {
        super.update()
        self.contentView?.frame = .init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
}
