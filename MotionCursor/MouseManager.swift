import Foundation
import Cocoa

class MouseManager {
    
    var bufferLocation: CGPoint!
    let displaySize: CGSize!
    let displayCenter: CGPoint!
    
    init() {
        displaySize = CGSize(width: NSScreen.main?.frame.width ?? 0.0, height: NSScreen.main?.frame.height ?? 0.0)
        displayCenter = CGPoint(x: displaySize.width / 2.0, y: displaySize.height / 2.0)
        bufferLocation = CGPoint(x: NSEvent.mouseLocation.x, y: NSEvent.mouseLocation.y)
    }
    
    
    func update(info: MouseInfo) {
        if info.type == MOUSE_TYPE.NORMAL.rawValue {
            let addPoint = CGPoint(x: info.acc?.x ?? 0.0, y: -(info.acc?.y ?? 0.0))
            let point = self.computePosition(now: bufferLocation, add: addPoint)
            let eventOpt = CGEvent(mouseEventSource: nil,
                                mouseType: CGEventType.mouseMoved,
                                mouseCursorPosition: point,
                                mouseButton: CGMouseButton(rawValue: UInt32(3))!)
            guard let event = eventOpt else { return }
            event.post(tap: .cghidEventTap)
            bufferLocation = point
        } else if info.type == MOUSE_TYPE.ThreeD.rawValue {
            guard let atti = info.atti else { return }
            let setPoint = CGPoint(x: displayCenter.x - CGFloat(atti.yaw) * (displaySize.width/2.0),
                                   y: displayCenter.y - CGFloat(atti.pitch) * (displaySize.height/2.0) )
            let eventOpt = CGEvent(mouseEventSource: nil,
                                mouseType: CGEventType.mouseMoved,
                                mouseCursorPosition: setPoint,
                                mouseButton: CGMouseButton(rawValue: UInt32(3))!)
            guard let event = eventOpt else { return }
            event.post(tap: .cghidEventTap)
        }

    }
    
    
    func computePosition(now: CGPoint, add: CGPoint) -> CGPoint {
        var x = now.x + add.x
        var y = now.y + add.y
        if x < 0 {
            x = 0
        }
        if x > displaySize.width {
            x = displaySize.width
        }
        if y < 0 {
            y = 0
        }
        if y > displaySize.height - 0.00390625 {
            y = displaySize.height - 0.00390625
        }
        return CGPoint(x: x, y: y)
    }
}
