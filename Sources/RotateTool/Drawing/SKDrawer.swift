//
//  SKDrawer.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import Spatial
import SwiftUI

struct SKDrawer: Equatable {
    
    let lineWidth: CGFloat
    
    let sphereMask: Path
    
    private let offset: CGSize
    
    private let strokeStyle: StrokeStyle
    
    init(sideSize: CGFloat) {
        lineWidth = (sideSize * 0.03).rounded()
        
        strokeStyle = StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        
        offset = CGSize(width: sideSize.half, height: sideSize.half)
        
        let sphereRadius = sideSize.half - lineWidth
        sphereMask = Path(ellipseIn: .zero.insetBy(dx: -sphereRadius, dy: -sphereRadius))
    }
    
    func draw(_ context: GraphicsContext, circles: [SKCircle3D], rotatingAxis: Axis3D?, drawBack: Bool = false) {
        var context = context
        
        context.translateBy(x: offset.width, y: offset.height)
        context.blendMode = .luminosity
        
        for circle in circles {
            let highlighted = (circle.backSemicircle.axis == rotatingAxis)
            
            var maskedContext = context
            
            if !drawBack {
                circle.frontSemicircle.draw(context, strokeStyle: strokeStyle, highlighted: highlighted)
                maskedContext.clip(to: sphereMask, options: .inverse)
            }
            
            circle.backSemicircle.draw(maskedContext, strokeStyle: strokeStyle, highlighted: highlighted)
        }
    }
}
