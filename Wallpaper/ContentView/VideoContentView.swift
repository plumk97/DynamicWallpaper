//
//  VideoContentView.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/26.
//

import Cocoa
import AVFoundation


class VideoContentView: ContentView {

    var playerLayer: AVPlayerLayer!
    
    override func commInit() {
        super.commInit()
        self.wantsLayer = true
        
        self.playerLayer = AVPlayerLayer(player: VideoSharePlayer.shared.queuePlayer)
        self.playerLayer.frame = self.bounds
        self.playerLayer.contentsGravity = .resize
        self.playerLayer.videoGravity = .resizeAspectFill
        self.layer?.addSublayer(self.playerLayer)
    }

    override func loadUrl(_ url: URL) {
        VideoSharePlayer.shared.loadUrl(url)
    }
    
    override func layout() {
        super.layout()
        self.playerLayer.frame = self.bounds
    }
}


// MARK: - VideoSharePlayer
fileprivate class VideoSharePlayer: NSObject {
    static let shared = VideoSharePlayer()
    
    let queuePlayer = AVQueuePlayer()
    
    private var looper: AVPlayerLooper?
    private var url: URL?
    
    private override init() {
        super.init()
        
        self.queuePlayer.isMuted = true
        self.queuePlayer.addObserver(self, forKeyPath: "status", options: .new, context: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(wallpaperDidChangeNotification), name: WallpaperDidChangeNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(screensDidSleepNotification), name: NSWorkspace.screensDidSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(screensDidWakeNotification), name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
    

    @objc func screensDidSleepNotification() {
        self.queuePlayer.pause()
    }
    
    @objc func screensDidWakeNotification() {
        self.queuePlayer.play()
    }
    
    @objc func wallpaperDidChangeNotification() {
        self.queuePlayer.pause()
        self.url = nil
        self.looper = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.queuePlayer.status == .readyToPlay {
            self.queuePlayer.play()
        }
    }
    
    func loadUrl(_ url: URL) {
        
        if self.url != url {
            
            let item = AVPlayerItem.init(url: url)
            guard item.asset.isPlayable else {
                return
            }
            
            self.url = url
            
            self.looper = AVPlayerLooper(player: self.queuePlayer, templateItem: item)
            
            if self.queuePlayer.status == .readyToPlay {
                self.queuePlayer.play()
            }
            
        }
    }
}
