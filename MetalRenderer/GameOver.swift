import Foundation

class GameOver: Scene {
    var win = false {
        didSet {
            print("Game over - ", win ? "You won" : "You lost")
        }
    }
    
    override func click(location: SIMD2<Float>) {
        let scene = Breakout(sceneSize: sceneSize)
        sceneDelegate?.transition(to:scene)
    }
}
