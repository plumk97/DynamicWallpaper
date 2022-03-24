function wallpaper_mouseMoveEvent(x, y) {
    var event = document.createEvent("MouseEvent")
    event.initMouseEvent("mousemove", true, false, window, 1, x, y, x, y, false, false, false, false, 0, null)
    document.dispatchEvent(event)
}


function wallpaper_mouseDownEvent(x, y) {
    var event = document.createEvent("MouseEvent")
    event.initMouseEvent("mousedown", true, false, window, 1, x, y, x, y, false, false, false, false, 0, null)
    document.dispatchEvent(event)
}


function wallpaper_mouseUpEvent(x, y) {
    var event = document.createEvent("MouseEvent")
    event.initMouseEvent("mouseup", true, false, window, 1, x, y, x, y, false, false, false, false, 0, null)
    document.dispatchEvent(event)
}

// 某些网页会判断当前是否在当前界面
document.hasFocus = function() {
    return true
}

// 屏蔽WebAudio 音频
AudioNode.prototype.connect = function(node) {
}
