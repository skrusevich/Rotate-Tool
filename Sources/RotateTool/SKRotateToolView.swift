//
//  SKRotateToolView.swift
//  RotateTool
//
//  Copyright © 2025 SV. All rights reserved.
//

import Spatial
import SwiftUI

public struct SKRotateToolView: View {
    
    @Binding private var rotation: Rotation3D
    
    @State private var rotationState = SKRotationState()
    
    public init(rotation: Binding<Rotation3D>) {
        _rotation = rotation
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let sideSize = min(proxy.size.width, proxy.size.height)
            
            ZStack {
                let padding = rotationState.lineWidth
                let colors = [Color.white, .black.opacity(0.6)]
                let blurRadius: CGFloat = sideSize / 75
                let gradientCenter = UnitPoint(x: 0.75, y: 0.25)
                
                Canvas { context, size in
                    rotationState.draw(context, drawBack: true)
                }
                .mask { Circle().padding(padding + blurRadius) }
                .blur(radius: blurRadius)
                
                RadialGradient(colors: colors, center: gradientCenter, startRadius: .zero, endRadius: sideSize)
                    .clipShape(Circle())
                    .padding(padding)
                
                Canvas { context, size in
                    rotationState.draw(context)
                }
            }
            .frame(maxWidth: sideSize, maxHeight: sideSize)
            .onContinuousHover { phase in
                if case .active(let point) = phase {
                    rotationState.applyGesture(.moving(point))
                }
                
#if os(macOS)
                if rotationState.isRotating {
                    if NSCursor.current != .pointingHand {
                        NSCursor.pointingHand.push()
                    }
                } else {
                    if NSCursor.current == .pointingHand {
                        NSCursor.pop()
                    }
                }
#endif
            }
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onChanged { value in
                        rotationState.applyGesture(.dragging(value.location))
                    }
                    .onEnded { _ in
                        rotationState.applyGesture(.endDragging)
                    }
            )
            .onAppear {
                rotationState.updateSize(proxy.size)
            }
            .onChange(of: proxy.size) { _, _ in
                rotationState.updateSize(proxy.size)
            }
        }
        .onChange(of: rotationState) { _, _ in
            if rotation != rotationState.rotation {
                rotation = rotationState.rotation
            }
        }
        .onChange(of: rotation) { _, _ in
            if rotation != rotationState.rotation {
                rotationState.updateRotation(rotation)
            }
        }
    }
}

public extension View {
    
    func rotatable(_ rotation: Binding<Rotation3D>, alignment: Alignment = .bottomLeading) -> some View {
        ZStack(alignment: alignment) {
            let axis = rotation.wrappedValue.axis
            let angle: Angle = .radians(rotation.wrappedValue.angle.radians)
            let sideSize: CGFloat = 100
            
            rotation3DEffect(angle, axis: (axis.x, axis.y, axis.z), perspective: .zero)
            
            SKRotateToolView(rotation: rotation)
                .frame(width: sideSize, height: sideSize)
        }
    }
}

#Preview {
    @Previewable @State var rotation = Rotation3D()
    
    ZStack {
        Circle()
            .fill(.blue)
        
        GeometryReader { proxy in
            let sideSize = min(proxy.size.width, proxy.size.height)
            let offset = CGSize(
                width: (proxy.size.width - sideSize).half,
                height: (proxy.size.height - sideSize).half
            )
            
            Path { path in
                path.move(to: .init(x: offset.width, y: offset.height + sideSize.half))
                path.addLine(to: .init(x: offset.width + sideSize, y: offset.height + sideSize.half))
            }
            .stroke(Color.red, lineWidth: 3)
            
            Path { path in
                path.move(to: .init(x: offset.width + sideSize.half, y: offset.height))
                path.addLine(to: .init(x: offset.width + sideSize.half, y: offset.height + sideSize))
            }
            .stroke(Color.green, lineWidth: 3)
        }
    }
    .rotatable($rotation)
}

