//
//  SKCircle3D.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import Spatial
import SwiftUI

struct SKCircle3D: Equatable {
    
    let backSemicircle: SKArc3D
    let frontSemicircle: SKArc3D
    
    var lineWidth = CGFloat.zero
    
    var semicircles: [SKArc3D] { [backSemicircle, frontSemicircle] }
    
    static let all = [Axis3D.x, .y, .z].map { circle(axis: $0) }
    
    static func circle(axis: Axis3D) -> Self {
        .init(backSemicircle: axis.arc(for: .back), frontSemicircle: axis.arc(for: .front))
    }
    
    func arc(for point: CGPoint, mask: Path) -> SKArc3D? {
        semicircles.first(where: { $0.contains(point, lineWidth: lineWidth, mask: mask) })
    }
    
    func applying(_ transform: AffineTransform3D, lineWidth: CGFloat) -> Self {
        Self(
            backSemicircle: backSemicircle.applying(transform),
            frontSemicircle: frontSemicircle.applying(transform),
            lineWidth: lineWidth
        )
    }
}
