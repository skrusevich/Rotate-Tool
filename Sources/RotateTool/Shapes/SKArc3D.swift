//
//  SKArc3D.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import SwiftUI
import Spatial

struct SKArc3D: Equatable {
    
    enum Position {
        case front
        case back
    }
    
    private(set) var start: Point3D = .start
    private(set) var middle: SKBezierPathElement3D = .middle
    private(set) var end: SKBezierPathElement3D = .end
    
    let axis: Axis3D
    let position: Position
    
    var path: Path { .init(arc: self) }
    
    func applying(_ transform: AffineTransform3D) -> Self {
        self * transform.rotated(by: (self * transform).correctionRotation)
    }
    
    static func * (lhs: Self, rhs: AffineTransform3D) -> Self {
        var result = lhs
        result.start = rhs * lhs.start
        result.middle = lhs.middle * rhs
        result.end = lhs.end * rhs
        return result
    }
}

// MARK: Calculations

extension SKArc3D {
    
    /// The third point is 0.
    var planeNormal: Vector3D {
        let a = middle.end.vector3D
        let b = (position == .back ? start : end.end).vector3D
        let n = a.cross(a - b).normalized
        return (n.x.isZero && n.y.isZero) ? Vector3D(x: -1) : Vector3D(x: n.y, y: -n.x)
    }
    
    /// Circle should be devided by Z plane.
    /// Calculate angle between a 0 b.
    fileprivate var correctionRotation: Rotation3D {
        let a = end.end.vector3D
        let b = planeNormal
        let length = (a.length.isZero || b.length.isZero) ? 1 : a.length * b.length
        let angle = Angle2D.acos((a.dot(b) / length).clamped(to: -1...1))
        return Rotation3D(angle: a.z.sign == .minus ? angle : -angle, axis: axis.rotationAxis)
    }
    
    func rotation(for point: Point3D, currentLength: CGFloat) -> Rotation3D {
        let newPoint = pointOnLine(point)
        let negate = (newPoint.dot(planeNormal).sign == .plus) != (position == .front)
        let angle = (newPoint.length - currentLength).invertingSign(negate)
        
        return Rotation3D(angle: .degrees(angle), axis: axis.rotationAxis)
    }
    
    private var normalLengthSquaredAsDivider: CGFloat {
        let lengthSquared = planeNormal.lengthSquared
        return lengthSquared.isZero ? 1 : lengthSquared
    }
    
    func pointOnLine(_ point: Point3D) -> Vector3D {
        planeNormal * planeNormal.dot(point.vector3D) / normalLengthSquaredAsDivider
    }
    
    func contains(_ point: CGPoint, lineWidth: CGFloat, mask: Path) -> Bool {
        path.pathToCheck(lineWidth: lineWidth).subtracting(position == .back ? mask : .init()).contains(point)
    }
}

// MARK: Drawing

extension SKArc3D {
    
    func draw(_ context: GraphicsContext, strokeStyle: StrokeStyle, highlighted: Bool) {
        context.stroke(path, with: highlighted ? axis.highlightShading : axis.shading, style: strokeStyle)
    }
}
