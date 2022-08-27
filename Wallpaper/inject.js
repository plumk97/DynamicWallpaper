
// 某些网页会判断当前是否在当前界面
document.hasFocus = function() {
    return true
}

// 屏蔽WebAudio 音频
AudioNode.prototype.connect = function(node) {
}
