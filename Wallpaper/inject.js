function wallpaper_mouseMoveEvent(x, y) {
    console.log(x, y)
    var event = document.createEvent("MouseEvent")
    event.initMouseEvent("mousemove", true, false, window, 1, x, y, x, y, false, false, false, false, 0, null)
    document.dispatchEvent(event)
}


function wallpaper_mouseDownEvent(x, y) {
    console.log(x, y)
    var event = document.createEvent("MouseEvent")
    event.initMouseEvent("mousedown", true, false, window, 1, x, y, x, y, false, false, false, false, 0, null)
    document.dispatchEvent(event)
}


function wallpaper_mouseUpEvent(x, y) {
    console.log(x, y)
    var event = document.createEvent("MouseEvent")
    event.initMouseEvent("mouseup", true, false, window, 1, x, y, x, y, false, false, false, false, 0, null)
    document.dispatchEvent(event)
}
