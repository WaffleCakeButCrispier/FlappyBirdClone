import Foundation
import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */


class Background : RenderableEntity {
    var isActive = false
    
    //visuals
    var firstRect = Rect(topLeft:Point(x:0,y:0), size:Size(width:100,height:100))
    var lastRect = Rect(topLeft:Point(x:0,y:0), size:Size(width:100,height:100))  
    
    var spriteLibrary : Image = Image(sourceURL: URL(string:"placeholder")!)
    var sprite : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:0,height:0)) 

    //velocity
    var velocityX : Double = 0.0
    var velocityY : Double = 0.0

    //initial positions
    var firstRectX = 0
    var lastRectX = 0
    
    //functions
    //import sprite from sprite library
    func sprite(spriteRect: Rect) {
        sprite = spriteRect
    }

    //setvelocity based on difficulty
    func setVelocity(velocity:Double) {
        velocityX = velocity
    }
    
    //set rect pos back to initial
    func reset() {
        print("reset background")
        firstRect.topLeft.x = firstRectX
        lastRect.topLeft.x = lastRectX
        isActive = false
    }
    
    override func calculate(canvasSize: Size) {
        guard let scene = scene as? MainScene else {
            fatalError("mainscene needed for background")
        }
        
        if scene.playing {
            isActive = true
        }
        
        if isActive && scene.playable && scene.playing {
            //test for outside/beyond the canvas Rect
            let canvasRect = Rect(topLeft: Point(x:0, y:0), size: canvasSize)

            let canvasContainmentFirst = canvasRect.containment(target: firstRect)
            if !canvasContainmentFirst.intersection([.beyondLeft]).isEmpty {
                firstRect.topLeft.x += canvasSize.width * 2
            }

            let canvasContainmentLast = canvasRect.containment(target: lastRect)
            if !canvasContainmentLast.intersection([.beyondLeft]).isEmpty {
                lastRect.topLeft.x += canvasSize.width * 2
            }
            
            //calculate new positions
            firstRect.topLeft.x += Int(velocityX)
            firstRect.topLeft.y += Int(velocityY)

            lastRect.topLeft.x += Int(velocityX)
            lastRect.topLeft.y += Int(velocityY)
            }
        }



    init() {
        
        super.init(name: "Background")         
         
    }

    override func setup(canvasSize: Size , canvas:Canvas) {
        //setup rects
        firstRect.size = canvasSize
        lastRect.size = canvasSize
        firstRectX = 0
        lastRectX = canvasSize.width
        firstRect.topLeft.x = 0
        lastRect.topLeft.x = canvasSize.width
    }
    
    override func render(canvas:Canvas) {
        //setup Sprites
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed to setup sprites for Background")
        }
        
        let rectangleBack = Rectangle(rect:firstRect, fillMode: .stroke)
        let rectangleFront = Rectangle(rect:lastRect, fillMode: .stroke)
        canvas.render(rectangleBack, rectangleFront)
        if scene.spriteLibraryReady {
            spriteLibrary = scene.returnSpriteLibrary()!
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:sprite, destinationRect: firstRect)
            canvas.render(spriteLibrary)
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:sprite, destinationRect: lastRect)
            canvas.render(spriteLibrary)
        }

    }
}
