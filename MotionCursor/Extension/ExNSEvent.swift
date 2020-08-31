//
//  ExNSEvent.swift
//  MotionCursor
//
//  Created by NH on 2020/08/31.
//  Copyright © 2020 NH. All rights reserved.
//

import Cocoa

extension NSEvent {
    static var mouseLocationCGPoint: CGPoint {
        get {
            return CGPoint(x: NSEvent.mouseLocation.x, y: (NSScreen.main?.frame.height ?? 0.0) - NSEvent.mouseLocation.y)
        }
    }
}
