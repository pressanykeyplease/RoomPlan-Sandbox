//
//  Int+toRadians.swift
//  Room Plan
//
//  Created by Eduard on 29.09.2022.
//

import Foundation

extension Int {
    func toRadians() -> CGFloat {
        CGFloat(self) * CGFloat.pi / 180
    }
}
