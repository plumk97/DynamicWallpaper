//
//  WallpaperWindow.swift
//  Wallpaper
//
//  Created by Plumk on 2021/8/30.
//

import Cocoa

class WallpaperWindow: NSWindow {
    
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
    
    convenience init(contentRect: NSRect, screen: NSScreen) {
        self.init(contentRect: contentRect, styleMask: [.borderless, .fullSizeContentView], backing: .buffered, defer: false, screen: screen)
        self.setup()
    }
    
    private func setup() {
        
        self.level = .init(Int(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)))
        self.hasShadow = false
        self.isReleasedWhenClosed = false
        self.ignoresMouseEvents = true
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
