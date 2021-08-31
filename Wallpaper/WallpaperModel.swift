//
//  WallpaperModel.swift
//  Wallpaper
//
//  Created by Plumk on 2021/8/31.
//

import Foundation

struct WallpaperModel: Hashable {
    enum WallpaperType: Int {
        case web = 0
        case image
        case video
    }
    
    let type: WallpaperType
    let url: URL
    
    init(type: WallpaperType, url: URL) {
        self.type = type
        self.url = url
    }
    
    init?(dict: [String: Any]) {
        guard let typeValue = dict["type"] as? Int,
              let urlString = dict["url"] as? String else {
            return nil
        }
        
        if let x = WallpaperType(rawValue: typeValue) {
            self.type = x
        } else {
            return nil
        }
        
        if let x = URL.init(string: urlString) {
            self.url = x
        } else {
            return nil
        }
    }
    
    func encode() -> [String: Any] {
        return [
            "type": self.type.rawValue,
            "url": self.url.absoluteString
        ]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.url)
        hasher.combine(self.type)
    }
    
    
}
