//
//  SKBezierPathElement3D.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import Spatial

// MARK: Constants

extension Point3D {
    
    /// [0, 1]
    static let start = Point3D(y: 1)
    
    /// [c, 1]
    fileprivate static let control = Point3D(x: 0.5522847498307935, y: 1)
}

struct SKBezierPathElement3D: Equatable {
    
    let end: Point3D
    let control1: Point3D
    let control2: Point3D
    
    /// [1, 0], [c, 1], [1, c]
    static let middle = Self(end: .start.swappedXY, control1: .control, control2: .control.swappedXY)
    
    /// [0, -1], [1, -c], [c, -1]
    static let end = middle.mirrored
    
    static func * (lhs: Self, rhs: AffineTransform3D) -> Self {
        Self(end: rhs * lhs.end, control1: rhs * lhs.control1, control2: rhs * lhs.control2)
    }
    
    private var mirrored: Self {
        Self(end: end.mirrored, control1: control1.mirrored, control2: control2.mirrored)
    }
}
