//
//  Application.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/25.
//

import Cocoa

class Application: NSApplication {
    
    var desktopHandleWindowNumbers = Set<Int>()
    
    let appDelegate = AppDelegate()
    override func run() {
        self.delegate = self.appDelegate
        super.run()
    }
    
    
}

let App = NSApp as! Application
