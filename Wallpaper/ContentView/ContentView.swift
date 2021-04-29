//
//  ContentView.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/26.
//

import Cocoa

class ContentView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.black.set()
        dirtyRect.fill()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.commInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commInit()
    }
    
    func commInit() {}
    
    func loadUrl(_ url: URL) {}
}
