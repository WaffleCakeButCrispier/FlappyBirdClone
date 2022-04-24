import Scenes
import Igis
import Foundation

class MainScene : Scene {

    //sprite status
    
    public var spriteLibraryReady = false
    
    //IMPORTANT LAYER
    let refreshLayer = RefreshLayer()
    
    //layers
    let backgroundLayer = BackgroundLayer()
    let interactionLayer = InteractionLayer()
    let foregroundLayer = ForegroundLayer()
    let spriteLayer = SpriteLayer()
    
    public var groundLevel = 800 //ground layer y 
    public var speed : Double = -10.0 //initial speed

    public var reset = false //should we reset?
    public var playable = true //is player playable (is bird uncontrollable)?
    public var playing = false //is player playing?
    public var isDying = false
    
    //get debug information
    public var debugInformation : [String] = []
    
    //get sprites
    func returnSpriteLibrary() -> Image? {
        spriteLayer.returnSpriteLibrary()
    }

    //global scene functions (return thine rectos)
    func returnDespawnRect() -> Rect { 
        let rect : Rect = interactionLayer.returnDespawnRect()
        return rect
    }

    func returnBirdRect() -> Rect {
        let rect : Rect = interactionLayer.returnBirdRect()
        return rect
    }

    func returnGroundRect() -> Rect {
        let rect : Rect = foregroundLayer.returnGroundRect()
        return rect        
    }
    
    //bird died
    func birdDeath() {
        interactionLayer.birdDeath()
        foregroundLayer.birdDeath()
    }

    //bird scored
    func birdScored() {
        foregroundLayer.birdScored()
    }
    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Main")
       
        // We insert our Layers in the constructor
        // We place each layer in front of the previous layer
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.front)
        insert(layer:foregroundLayer, at:.front)
        insert(layer:refreshLayer, at:.back)
        insert(layer:spriteLayer, at:.back)
    }

    override func preCalculate(canvas:Canvas) {
        debugInformation.append("MainScene Data: Attributes: groundLevel: \(groundLevel) reset: \(reset) splayable: \(playable), playing:\(playing)")
    }
    
}
