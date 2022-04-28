import Scenes
import Igis
import Foundation

class Ground : RenderableEntity {

    var isActive = false
    
    //visuals
    var groundBoundingRect = Rect(topLeft: Point(x:0, y:0), size:Size(width: 1000, height:500))
    var firstGroundRect = Rect(topLeft: Point(x:0, y:0), size:Size(width: 1000, height:500))
    var lastGroundRect = Rect(topLeft: Point(x:0, y:0), size:Size(width: 1000, height:500))
    
    var spriteLibrary : Image = Image(sourceURL: URL(string:"placeholder")!)
    var sprite : Rect = Rect(topLeft:Point(x:0,y:972), size:Size(width:576,height:324)) 

    //velocityd
    var velocityX : Double = -10.0
    
    
    //return bounding Rect
    func returnGroundRect() -> Rect {
        return groundBoundingRect
    }
    
    init() {
        super.init(name:"Ground")
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

            let canvasContainmentFirst = canvasRect.containment(target: firstGroundRect)
            if !canvasContainmentFirst.intersection([.beyondLeft]).isEmpty {
                firstGroundRect.topLeft.x += (canvasSize.width * 2)
            }

            let canvasContainmentLast = canvasRect.containment(target: lastGroundRect)
            if !canvasContainmentLast.intersection([.beyondLeft]).isEmpty {
                lastGroundRect.topLeft.x += (canvasSize.width * 2)
            }
            
            //calculate new positions
            firstGroundRect.topLeft.x += Int(velocityX)

            lastGroundRect.topLeft.x += Int(velocityX)
            }
        }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene is needed for Ground setup")
        }
        groundBoundingRect.size.width = canvasSize.width + 5
        groundBoundingRect.topLeft.y = scene.groundLevel

        firstGroundRect.size.width = canvasSize.width + 5
        firstGroundRect.topLeft.y = scene.groundLevel

        lastGroundRect.size.width = canvasSize.width + 5
        lastGroundRect.topLeft.y = scene.groundLevel
        lastGroundRect.topLeft.x += canvasSize.width
        
        let groundRectangle = Rectangle(rect: groundBoundingRect, fillMode:.stroke)
        canvas.render(groundRectangle)
    }
    
    override func render(canvas: Canvas) {
        //setup Sprites
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed to setup sprites for Background")
        }
        
        let rectangleBack = Rectangle(rect:firstGroundRect, fillMode: .stroke)
        let rectangleFront = Rectangle(rect:lastGroundRect, fillMode: .stroke)
        canvas.render(rectangleBack, rectangleFront)
        if scene.spriteLibraryReady {
            spriteLibrary = scene.returnSpriteLibrary()!
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:sprite, destinationRect: firstGroundRect)
            canvas.render(spriteLibrary)
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:sprite, destinationRect: lastGroundRect)
            canvas.render(spriteLibrary)
        }
            }
}
