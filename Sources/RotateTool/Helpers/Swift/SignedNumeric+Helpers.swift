//
//  SignedNumeric+Helpers.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

extension SignedNumeric {
    
    func invertingSign(_ inverse: Bool) -> Self {
        inverse ? -self : self
    }
}
