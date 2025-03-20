//
//  CGPoint+Helpers.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import CoreFoundation
import Spatial

extension CGPoint {
    
    var point3D: Point3D { Point3D(x: x, y: y) }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    func offsetBy(_ offset: CGSize) -> CGPoint {
        CGPoint(x: x + offset.width, y: y + offset.height)
    }
}
