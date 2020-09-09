//
//  MouseCoreOperate.swift
//  MotionCursor
//
//  Created by NH on 2020/08/31.
//  Copyright © 2020 NH. All rights reserved.
//

import Cocoa

class MouseEvent {
    static func leftDown() {
        let eventOpt = CGEvent(mouseEventSource: nil,
                               mouseType: .leftMouseDown,
                               mouseCursorPosition: NSEvent.mouseLocationCGPoint,
                               mouseButton: .left)
        guard let event = eventOpt else { return }
        event.post(tap: .cghidEventTap)
        print("DOWN")
    }
    
    static func leftUp() {
        let eventOpt = CGEvent(mouseEventSource: nil,
                               mouseType: .leftMouseUp,
                               mouseCursorPosition: NSEvent.mouseLocationCGPoint,
                               mouseButton: .left)
        guard let event = eventOpt else { return }
        event.post(tap: .cghidEventTap)
        print("UP")
    }
    
    static func leftClick() {
        MouseEvent.leftDown()
        MouseEvent.leftUp()
    }
    
    static func doubleLeftClick() {
        MouseEvent.leftClick()
        MouseEvent.leftClick()
    }
}
