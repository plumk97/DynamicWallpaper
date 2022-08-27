//
//  StatusBarWindow.swift
//  Wallpaper
//
//  Created by litiezhu on 2022/8/27.
//

import Cocoa

class StatusBarWindow: NSWindow {
    
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
    
    convenience init( screen: NSScreen) {
        let barHeight = screen.frame.height - screen.visibleFrame.height
        self.init(contentRect: .init(x: 0, y: screen.frame.height - barHeight, width: screen.frame.width, height: barHeight), styleMask: [.borderless, .fullSizeContentView], backing: .buffered, defer: false, screen: screen)
        self.setup()
    }
    
    func setup() {
        
        self.level = .init(Int(CGWindowLevelForKey(.mainMenuWindow)))
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        self.hasShadow = false
        self.isReleasedWhenClosed = false
        self.ignoresMouseEvents = true
        
    }
}
