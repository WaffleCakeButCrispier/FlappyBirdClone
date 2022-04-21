import Scenes
import Igis
import Foundation

class MainScene : Scene {

    //IMPORTANT SPRITES (contains all sprites needed) 
    public let spriteLibrary : Image 

    //IMPORTANT LAYER
    let refreshLayer = RefreshLayer()
    
    //layers
    let backgroundLayer = BackgroundLayer()
    let interactionLayer = InteractionLayer()
    let foregroundLayer = ForegroundLayer()
    
    public var groundLevel = 850 //ground layer y 
    public var speed : Double = -10.0 //initial speed

    public var reset = false //should we reset?
    public var playable = true //is player playable (is bird uncontrollable)?
    public var playing = false //is player playing?
    
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
        guard let spriteLibraryUrl = URL(string:"https://www.thoughtco.com/thmb/Zya6PS3m6XjRAmVo1HONvY9DW_A=/3865x2174/smart/filters:no_upscale()/abstract-paper-flower-pattern-656688606-5acfba2eae9ab80038461ca0.jpg") else {
            fatalError("failed to load sprite library url")
        }
        spriteLibrary = Image(sourceURL: spriteLibraryUrl)
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Main")
       
        // We insert our Layers in the constructor
        // We place each layer in front of the previous layer
        insert(layer:backgroundLayer, at:.back)
        insert(layer:interactionLayer, at:.front)
        insert(layer:foregroundLayer, at:.front)
        insert(layer:refreshLayer, at:.back)

    }

    override func preSetup(canvasSize: Size, canvas:Canvas) {
        canvas.setup(spriteLibrary)
        // //wait for sprites to load
        // var loading = true
        // while !spriteLibrary.isReady {
        //     if loading {
        //         print("loadingSprites")
        //         loading = false
        //     }
        // }
        // print("url loaded")
    }
}
