//
//  Path+Helpers.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import SwiftUI

extension Path {
    
    init(arc: SKArc3D) {
        self.init()
        
        move(to: arc.start.cgPoint)
        addCurve(arc.middle)
        addCurve(arc.end)
    }
    
    mutating func addCurve(_ element: SKBezierPathElement3D) {
        addCurve(to: element.end.cgPoint, control1: element.control1.cgPoint, control2: element.control2.cgPoint)
    }
    
    func pathToCheck(lineWidth: CGFloat) -> Self {
        strokedPath(.init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
    }
}
