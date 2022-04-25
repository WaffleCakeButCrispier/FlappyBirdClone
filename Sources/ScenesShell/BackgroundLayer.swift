import Scenes
import Igis
/*
 This class is responsible for the background Layer.
 Internally, it maintains the RenderableEntities for this layer.
 */


class BackgroundLayer : Layer {
    
    let backgroundFirst = Background()
    let backgroundMid = Background()
    let backgroundLast = Background()
    
    override func preSetup(canvasSize: Size, canvas:Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("mainscene required to precalculate in background layer")
        }
        let speed = scene.speed
        
        //setup background velocities and sprites
        backgroundFirst.setVelocity(velocity: speed * 0.5)
        backgroundFirst.sprite(spriteRect: Rect(topLeft:Point(x:0,y:0), size:Size(width:canvasSize.width / 4, height:canvasSize.height / 4)))
        backgroundMid.setVelocity(velocity: speed * 0.25)
        backgroundMid.sprite(spriteRect: Rect(topLeft:Point(x:0,y:0), size:Size(width:canvasSize.width / 2, height:canvasSize.height / 2)))
        backgroundLast.setVelocity(velocity: speed * 0.1)
        backgroundLast.sprite(spriteRect: Rect(topLeft:Point(x:0,y:0), size:Size(width:canvasSize.width, height:canvasSize.height)))
    }
    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")

        // We insert our RenderableEntities in the constructor
        insert(entity:backgroundFirst, at:.back)
        insert(entity:backgroundMid, at:.back)
        insert(entity:backgroundLast, at:.back)
    }
}
