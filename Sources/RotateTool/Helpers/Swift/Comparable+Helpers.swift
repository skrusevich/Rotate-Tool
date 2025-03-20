//
//  Comparable+Helpers.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

extension Comparable {
    
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
