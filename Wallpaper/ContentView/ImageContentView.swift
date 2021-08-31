//
//  ImageContentView.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/26.
//

import Cocoa

class ImageContentView: ContentView {

    var imageView: NSImageView!
    override func commInit() {
        super.commInit()
        self.imageView = NSImageView(frame: self.bounds)
        self.imageView.imageScaling = .scaleProportionallyUpOrDown
        self.addSubview(self.imageView)
    }
    
    override func loadUrl(_ url: URL) {
        super.loadUrl(url)
        self.imageView.image = NSImage(contentsOf: url)
    }
    
    override func layout() {
        super.layout()
        self.imageView.frame = self.bounds
    }
}
