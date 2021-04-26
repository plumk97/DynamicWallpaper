//
//  AppleScript.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/26.
//

import Foundation
import AppKit

class AppleScript {
    
    static func inputUrl() -> String? {
        guard let script = NSAppleScript(source: "display dialog \"请输入网页地址\" buttons {\"取消\", \"确认\"} default button 2 default answer \"\"") else {
            return nil
        }
        
        var error: NSDictionary?
        let ret = script.executeAndReturnError(&error)
        
        if ret.numberOfItems > 0 {
            if ret.atIndex(1)?.stringValue == "取消" {
                return nil
            }
        }
        
        if ret.numberOfItems > 1 {
            return ret.atIndex(2)?.stringValue
        }
        
        return nil
    }
}
