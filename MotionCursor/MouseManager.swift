import Foundation
import Cocoa

class MouseManager {
    
    var bufferLocation: CGPoint!
    let display_w: CGFloat!
    let display_h: CGFloat!
    
    init() {
        display_w = NSScreen.main?.frame.width ?? 0.0
        display_h = NSScreen.main?.frame.height ?? 0.0
        bufferLocation = CGPoint(x: NSEvent.mouseLocation.x, y: NSEvent.mouseLocation.y)
    }
    
    
    func update(info: MouseInfo) {
        let addPoint = CGPoint(x: info.acc.x, y: -info.acc.y)
        let point = self.computePosition(now: bufferLocation, add: addPoint)
        let eventOpt = CGEvent(mouseEventSource: nil,
                            mouseType: CGEventType.mouseMoved,
                            mouseCursorPosition: point,
                            mouseButton: CGMouseButton(rawValue: UInt32(3))!)
        guard let event = eventOpt else { return }
        event.post(tap: .cghidEventTap)
        bufferLocation = point
    }
    
    
    func computePosition(now: CGPoint, add: CGPoint) -> CGPoint {
        var x = now.x + add.x
        var y = now.y + add.y
        if x < 0 {
            x = 0
        }
        if x > display_w {
            x = display_w
        }
        if y < 0 {
            y = 0
        }
        if y > display_h - 0.00390625 {
            y = display_h - 0.00390625
        }
        return CGPoint(x: x, y: y)
    }
}
