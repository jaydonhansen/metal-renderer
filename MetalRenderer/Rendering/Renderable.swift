import Foundation
import MetalKit

protocol Renderable {
    var name: String { get }
    func render(commandEncoder: MTLRenderCommandEncoder,
                uniforms: Uniforms,
                fragmentUniforms: FragmentUniforms)
}
