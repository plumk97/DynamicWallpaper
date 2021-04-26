//
//  Application.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/25.
//

import Cocoa

class Application: NSApplication {

    let appDelegate = AppDelegate()
    override func run() {
        self.delegate = self.appDelegate
        super.run()
    }
    
    
}
