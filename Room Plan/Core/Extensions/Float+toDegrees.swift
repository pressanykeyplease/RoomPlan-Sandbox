//
//  Float+toDegrees.swift
//  Room Plan
//
//  Created by Eduard on 29.09.2022.
//

import Foundation

extension Float {
    func toDegrees() -> Int {
        Int(CGFloat(self) * 180 / CGFloat.pi)
    }
}
