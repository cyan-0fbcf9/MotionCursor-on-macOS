//
//  BluetoothListener.swift
//  MotionCursor
//
//  Created by NH on 2020/08/31.
//  Copyright © 2020 NH. All rights reserved.
//

import Foundation

protocol BluetoothListener {
    func notifyCursor(data: Data) -> Void
    func notifyAction(data: Data) -> Void
}
