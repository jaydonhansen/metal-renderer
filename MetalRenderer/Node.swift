import Foundation
import ModelIO

class Node {
    var name = "Untitled"
    
    var children: [Node] = []
    var parent: Node?
    
    var position = SIMD3<Float>(repeating: 0)
    var rotation = SIMD3<Float>(repeating: 0)
    var scale: Float = 1
    
    var matrix: float4x4  {
        let translateMatrix = float4x4(translation: position)
        let rotationMatrix = float4x4(rotation: rotation)
        let scaleMatrix = float4x4(scaling: scale)
        return translateMatrix * scaleMatrix * rotationMatrix
    }
    
    var worldMatrix: float4x4 {
        if let parent = parent {
            return parent.worldMatrix * matrix
        }
        return matrix
    }
    
    var boundingBox = MDLAxisAlignedBoundingBox()
    
    final func add(childNode: Node) {
        children.append(childNode)
        childNode.parent = self
    }
    
    final func remove(childNode: Node) {
        for child in childNode.children {
            child.parent = self
            children.append(child)
        }
        childNode.children = []
        guard let index = (children.firstIndex {
            $0 === childNode
        }) else { return }
        children.remove(at: index)
    }
    
    func worldBoundingBox (matrix: float4x4? = nil) -> Rect {
        var worldMatrix = self.worldMatrix
        if let matrix = matrix {
            worldMatrix = worldMatrix * matrix
        }
        var lowerLeft = SIMD4<Float>(boundingBox.minBounds.x, 0, boundingBox.minBounds.z, 1)
        lowerLeft = worldMatrix * lowerLeft
        
        var upperRight = SIMD4<Float>(boundingBox.maxBounds.x, 0, boundingBox.maxBounds.z, 1)
        upperRight = worldMatrix * upperRight
        
        return Rect(x: lowerLeft.x,
                    z: lowerLeft.z,
                    width: upperRight.x - lowerLeft.x,
                    height: upperRight.z - lowerLeft.z)
    }
    
}
