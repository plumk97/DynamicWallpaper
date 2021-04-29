//
//  WebContentView.swift
//  Wallpaper
//
//  Created by Plumk on 2021/4/25.
//

import Cocoa
import WebKit

class WebContentView: ContentView {

    class WebView: WKWebView {
        override func draw(_ dirtyRect: NSRect) {
            super.draw(dirtyRect)
            NSColor.black.set()
            dirtyRect.fill()
        }
    }

    var webview: WKWebView!
    
    private var currentUrl: URL?
    private var mouseMonitor: Any?
    override func commInit() {
        super.commInit()
        let conf = WKWebViewConfiguration()
        conf.preferences.javaScriptCanOpenWindowsAutomatically = false
        conf.allowsAirPlayForMediaPlayback = false
        conf.mediaTypesRequiringUserActionForPlayback = .all
        
        if let path = Bundle.main.path(forResource: "inject", ofType: "js"), let str = try? String.init(contentsOfFile: path) {
            conf.userContentController.addUserScript(.init(source: str, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        }
        
        self.webview = WebView(frame: self.bounds, configuration: conf)
        self.webview.navigationDelegate = self
        self.webview.allowsBackForwardNavigationGestures = false
        self.webview.uiDelegate = self
        self.addSubview(self.webview)
        
        self.webview.loadHTMLString("<!DOCTYPE html><html><head></head><body style='background-color: black'></body></html>", baseURL: nil)
        
        // -- Event
        let screenBounds = NSScreen.main!.frame
        self.mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: [
            .mouseMoved, .leftMouseDown, .leftMouseUp
        ]) {[unowned self] (event) in
            var point = event.locationInWindow
            point.y = screenBounds.height - point.y
            switch event.type {
            case .mouseMoved:
                self.webview.evaluateJavaScript("wallpaper_mouseMoveEvent(\(point.x), \(point.y))")
            case .leftMouseDown:
                self.webview.evaluateJavaScript("wallpaper_mouseDownEvent(\(point.x), \(point.y))")
            case .leftMouseUp:
                self.webview.evaluateJavaScript("wallpaper_mouseUpEvent(\(point.x), \(point.y))")
            default:
                break
            }
        }
    }
    
    private func enumSubViews(_ view: NSView ,callback: (NSView)->Void) {
        for view1 in view.subviews {
            callback(view1)
            self.enumSubViews(view1, callback: callback)
        }
    }
    
    override func loadUrl(_ url: URL) {
        super.loadUrl(url)
        self.currentUrl = url
        if url.isFileURL {
            self.webview.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else {
            self.webview.load(.init(url: url))
        }
    }
    
    deinit {
        if let obj = self.mouseMonitor {
            NSEvent.removeMonitor(obj)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebContentView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard navigationAction.navigationType == .other else {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
}

// MARK: - WKUIDelegate
extension WebContentView: WKUIDelegate {
    
}
