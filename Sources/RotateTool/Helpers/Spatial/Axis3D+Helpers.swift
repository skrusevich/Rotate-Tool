//
//  Axis3D+Helpers.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import Spatial
import SwiftUI

extension Axis3D {
    
    func arc(for position: SKArc3D.Position) -> SKArc3D {
        .init(axis: self, position: position) * initialTransform(for: position)
    }
    
    var rotationAxis: RotationAxis3D {
        switch self {
        case .x: .x
        case .y: .y
        case .z: .z
        default: .zero
        }
    }
    
    private var initialRotation: Rotation3D {
        switch self {
        case .x: .init(angle: .radians(.pi / 2), axis: .y)
        case .y: .init(angle: -.radians(.pi / 2), axis: .x)
        default: .identity
        }
    }
    
    private var scale: Size3D {
        switch self {
        case .x: Size3D(width: 1, height: -1, depth: 1)
        default: Size3D(width: -1, height: 1, depth: 1)
        }
    }
    
    func initialTransform(for position: SKArc3D.Position) -> AffineTransform3D {
        (position == .back ? .identity : AffineTransform3D(scale: scale)).rotated(by: initialRotation)
    }
    
    private var color: Color {
        switch self {
        case .x: .green
        case .y: .red
        case .z: .blue
        default: .clear
        }
    }
    
    var shading: GraphicsContext.Shading {
        .color(color)
    }
    
    var highlightShading: GraphicsContext.Shading {
        .color(color.opacity(0.7))
    }
}
