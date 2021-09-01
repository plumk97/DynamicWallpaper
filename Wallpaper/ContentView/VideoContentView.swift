//
//  VideoContentView.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/26.
//

import Cocoa
import AVFoundation

class VideoContentView: ContentView {


    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    override func commInit() {
        super.commInit()
        self.wantsLayer = true
        self.player = AVPlayer()
        self.player.isMuted = true
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.frame = self.bounds
        self.playerLayer.contentsGravity = .resize
        self.playerLayer.videoGravity = .resizeAspectFill
        self.layer?.addSublayer(self.playerLayer)
        
        self.player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    deinit {
        self.player.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func playerItemDidPlayToEndTime() {
        self.player.seek(to: .zero)
        self.player.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.player.status == .readyToPlay {
            self.player.play()
            
        }
    }
    
    override func loadUrl(_ url: URL) {
        self.player.replaceCurrentItem(with: .init(url: url))
    }
    
    
    override func layout() {
        super.layout()
        self.playerLayer.frame = self.bounds
    }
}
