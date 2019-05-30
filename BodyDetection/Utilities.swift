/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Utility functions that support the sample app.
*/

import Foundation
import RealityKit
import ARKit

extension MeshResource {
    /**
     Generate three axes of a coordinate system with x axis = red, y axis = green and z axis = blue
     - parameters:
     - axisLength: Length of the axes in m
     - thickness: Thickness of the axes as a percentage of their length
     */
    static func generateCoordinateSystemAxes(length: Float = 0.1, thickness: Float = 2.0) -> Entity {
        let thicknessInM = (length / 100) * thickness
        let cornerRadius = thickness / 2.0
        let offset = length / 2.0
        
        let xAxisBox = MeshResource.generateBox(size: [length, thicknessInM, thicknessInM], cornerRadius: cornerRadius)
        let yAxisBox = MeshResource.generateBox(size: [thicknessInM, length, thicknessInM], cornerRadius: cornerRadius)
        let zAxisBox = MeshResource.generateBox(size: [thicknessInM, thicknessInM, length], cornerRadius: cornerRadius)
    
        let xAxis = ModelEntity(mesh: xAxisBox, materials: [UnlitMaterial(color: .red)])
        let yAxis = ModelEntity(mesh: yAxisBox, materials: [UnlitMaterial(color: .green)])
        let zAxis = ModelEntity(mesh: zAxisBox, materials: [UnlitMaterial(color: .blue)])
        
        xAxis.position = [offset, 0, 0]
        yAxis.position = [0, offset, 0]
        zAxis.position = [0, 0, offset]
        
        let axes = Entity()
        axes.addChild(xAxis)
        axes.addChild(yAxis)
        axes.addChild(zAxis)
        return axes
    }
}
