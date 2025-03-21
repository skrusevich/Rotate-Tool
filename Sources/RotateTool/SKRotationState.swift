//
//  SKRotationState.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import Spatial
import SwiftUI

struct SKRotationState: Equatable {
    
    enum SKGesture {
        case dragging(CGPoint)
        case endDragging
        case moving(CGPoint)
    }
    
    private var drawer = SKDrawer(sideSize: .zero)
    private var rotator = SKRotator()
    
    private var offset: CGSize = .zero
    
    private let circles = SKCircle3D.all
    
    var transformedCircles: [SKCircle3D] {
        circles.map { $0.applying(rotator.transform, lineWidth: lineWidth) }
    }
    
    var lineWidth: CGFloat { drawer.lineWidth }
    var rotation: Rotation3D { rotator.rotation }
    var isRotating: Bool { rotator.rotatingSemicircle != nil }
    
    // MARK: Updating
    
    mutating func updateRotation(_ rotation: Rotation3D) {
        rotator.updateRotation(rotation)
    }
    
    mutating func updateSize(_ size: CGSize) {
        let sideSize = min(size.width, size.height)
        drawer = SKDrawer(sideSize: sideSize)
        rotator.updateRadius((sideSize - drawer.lineWidth).half)
        offset = CGSize(width: -sideSize.half, height: -sideSize.half)
    }
    
    mutating func reset() {
        rotator.reset()
    }
    
    // MARK: Gestures
    
    mutating func applyGesture(_ gesture: SKGesture) {
        switch gesture {
        case .dragging(let point):
            if !isRotating {
                highlightAxis(point)
            } else {
                rotator.rotate(point)
            }
        case .endDragging:
            rotator.finishRotating()
        case .moving(let point):
            highlightAxis(point)
        }
    }
    
    private mutating func highlightAxis(_ point: CGPoint) {
        let arc = transformedCircles.compactMap({ $0.arc(for: point.offsetBy(offset), mask: drawer.sphereMask) }).first
        
        if rotator.rotatingSemicircle != arc {
            rotator.rotatingSemicircle = arc
        }
    }
    
    // MARK: Drawing
    
    func draw(_ context: GraphicsContext, drawBack: Bool = false) {
        let rotatingAxis = rotator.rotatingSemicircle?.axis
        drawer.draw(context, circles: transformedCircles, rotatingAxis: rotatingAxis, drawBack: drawBack)
    }
}
