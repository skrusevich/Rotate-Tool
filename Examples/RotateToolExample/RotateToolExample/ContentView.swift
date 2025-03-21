//
//  ContentView.swift
//  RotateToolExample
//
//  Copyright © 2025 SV. All rights reserved.
//

import SwiftUI
import RotateTool
import Spatial

extension GraphicsContext.BlendMode: @retroactive Hashable {
}

struct ContentView: View {
    
    @State var animate = false
    
    @State var animatedAxis = RotationAxis3D.x
    @State var direction: Double = 1
    
    @State var rotation: Rotation3D = .identity
    
    func rotation(for axis: RotationAxis3D, delta: CGFloat) -> Rotation3D? {
        let newRotation = Rotation3D(angle: .degrees(delta), axis: axis)
        return AffineTransform3D(rotation: rotation).rotated(by: newRotation).rotation
    }
    
    var eulerAngles: simd_double3 {
        rotation.eulerAngles(order: .xyz).angles
    }
    
    var xRotation: CGFloat { Angle2D(radians: eulerAngles.x).degrees }
    var yRotation: CGFloat { Angle2D(radians: eulerAngles.y).degrees }
    var zRotation: CGFloat { Angle2D(radians: eulerAngles.z).degrees }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Button(animate ? "Stop Animation" : "Start Animation") {
                    animate.toggle()
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { _ in
                        Task { @MainActor in
                            if animate {
                                rotation = rotation(for: animatedAxis, delta: direction) ?? rotation
                            }
                        }
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        Task { @MainActor in
                            direction = [1, -1].randomElement() ?? direction
                            animatedAxis = [.x, .y, .z].randomElement() ?? animatedAxis
                        }
                    }
                }
                
                Button("Reset") {
                    rotation = .identity
                    animate = false
                }
            }
            
            Spacer()
            
            slider(value: xRotation, axis: .x)
            slider(value: yRotation, axis: .y)
            slider(value: zRotation, axis: .z)
            
            Spacer()
            
            GeometryReader { proxy in
                let sideSize = min(proxy.size.width, proxy.size.height)
                let lineWidth: CGFloat = sideSize * 0.03
                
                let offset = CGSize(
                    width: (proxy.size.width - sideSize) / 2,
                    height: (proxy.size.height - sideSize) / 2
                )
                
                ZStack {
                    Path(ellipseIn: .init(x: offset.width, y: offset.height, width: sideSize, height: sideSize))
                        .fill(
                            RadialGradient(
                                colors: [.white, .blue],
                                center: .init(x: 0.75, y: 0.25),
                                startRadius: .zero,
                                endRadius: sideSize
                            )
                        )
                    
                    Path { path in
                        path.move(to: .init(x: offset.width, y: offset.height + sideSize / 2))
                        path.addLine(to: .init(x: offset.width + sideSize, y: offset.height + sideSize / 2))
                    }
                    .stroke(Color.red, lineWidth: lineWidth)
                    
                    Path { path in
                        path.move(to: .init(x: offset.width + sideSize / 2, y: offset.height))
                        path.addLine(to: .init(x: offset.width + sideSize / 2, y: offset.height + sideSize))
                    }
                    .stroke(Color.green, lineWidth: lineWidth)
                }
            }
            .rotatable($rotation)
        }
        .padding()
    }
    
    @ViewBuilder private func slider(value: CGFloat, axis: RotationAxis3D) -> some View {
        let text = switch axis {
        case .x: "x \(Int(value))"
        case .y: "y \(Int(value))"
        case .z: "z \(Int(value))"
        default: ""
        }
        
        Stepper(
            text,
            value: .init(get: { value }, set: { rotation = rotation(for: axis, delta: ($0 - value)) ?? rotation }),
            in: -179...179,
            step: 5
        )
    }
}

#Preview {
    ContentView()
}
