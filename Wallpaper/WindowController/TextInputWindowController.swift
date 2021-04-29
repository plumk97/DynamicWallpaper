//
//  TextInputWindowController.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/29.
//

import Cocoa


class TextInputWindowController: WindowController {

    var confirmCallback: ((String) -> Void)?
    
    @IBOutlet weak var textField: TextField!
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.level = .modalPanel
        self.window?.isMovableByWindowBackground = true
        self.window?.titleVisibility = .hidden
        self.window?.titlebarAppearsTransparent = true
        self.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.window?.standardWindowButton(.zoomButton)?.isHidden = true
        self.window?.standardWindowButton(.closeButton)?.isHidden = true
        
        self.window?.identifier = .init("TextInputWindowController")
        self.window?.center()
        
    }
    
    @IBAction func cancelBtnClick(_ sender: NSButton) {
        self.close()
    }
    
    @IBAction func confirmBtnClick(_ sender: NSButton) {
        self.close()
        self.confirmCallback?(self.textField.stringValue)
    }
    
}
