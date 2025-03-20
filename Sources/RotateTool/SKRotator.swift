//
//  SKRotator.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import Spatial
import SwiftUI

struct SKRotator: Equatable {
    
    var rotatingSemicircle: SKArc3D?
    
    var transform: AffineTransform3D = .identity
    
    private var currentLength: Double?
    
    private var defaultTransform: AffineTransform3D = .identity
    
    var eulerAngles: simd_double3 {
        transform.rotation?.eulerAngles(order: .xyz).angles ?? .zero
    }
    
    var rotation: Rotation3D {
        transform.rotation ?? .identity
    }
    
    mutating func reset() {
        transform = defaultTransform
    }
    
    mutating func rotate(_ point: CGPoint) {
        if let currentLength, let arc = rotatingSemicircle {
            transform.rotate(by: arc.rotation(for: point.point3D, currentLength: currentLength))
            self.currentLength = arc.pointOnLine(point.point3D).length
        } else {
            currentLength = rotatingSemicircle?.pointOnLine(point.point3D).length
        }
    }
    
    mutating func finishRotating() {
        currentLength = nil
        rotatingSemicircle = nil
    }
    
    mutating func updateRotation(_ rotation: Rotation3D) {
        transform = .init(rotation: rotation).concatenating(defaultTransform)
    }
    
    mutating func updateRadius(_ radius: CGFloat) {
        let scale = Size3D(width: radius, height: radius, depth: radius)
        defaultTransform = AffineTransform3D(scale: scale)
        
        transform = defaultTransform.rotated(by: rotation)
    }
}
