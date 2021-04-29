//
//  WindowController.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/29.
//

import Cocoa

var WindowControllerHolderSet = Set<WindowController>()

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        WindowControllerHolderSet.insert(self)
    }
    
    static func loadFromNib() -> Self {
        return self.init(windowNibName: self.className().components(separatedBy: ".").last ?? "")
    }
    
    override func close() {
        super.close()
        WindowControllerHolderSet.remove(self)
    }

}
