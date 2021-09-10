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
        
        self.playerLayer = AVPlayerLayer(player: VideoSharePlayer.shared.player)
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
    
    let player = AVPlayer()
    private var url: URL?
    private override init() {
        super.init()
        self.player.isMuted = true
        
        
        self.player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(screensDidSleepNotification), name: NSWorkspace.screensDidSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(screensDidWakeNotification), name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
    
    @objc func playerItemDidPlayToEndTime() {
        self.player.seek(to: .zero)
        self.player.play()
    }
    
    @objc func screensDidSleepNotification() {
        self.player.pause()
    }
    
    @objc func screensDidWakeNotification() {
        self.player.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.player.status == .readyToPlay {
            self.player.play()
        }
    }
    
    func loadUrl(_ url: URL) {
        
        if self.url != url {
            self.url = url
            self.player.replaceCurrentItem(with: .init(url: url))
        }
    }
}
