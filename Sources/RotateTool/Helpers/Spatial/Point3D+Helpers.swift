//
//  Point3D+Helpers.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import CoreGraphics
import Spatial

extension Point3D {
    
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
    
    var flippedY: Point3D { Self(x: x, y: -y) }
    var swappedXY: Point3D { Self(x: y, y: x) }
    var mirrored: Point3D { swappedXY.flippedY }
    
    var vector3D: Vector3D { Vector3D(vector: vector) }
}
