import Scenes
import Igis
import Foundation

class Ground : RenderableEntity {
    
    //visuals
    var groundBoundingRect = Rect(topLeft: Point(x:0, y:0), size:Size(width: 1000, height:100))

    //sprite
    var spriteLibrary : Image = Image(sourceURL: URL(string:"placeholder")!)
    var sprite : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:50,height:100)) 

    //return bounding Rect
    func returnGroundRect() -> Rect {
        return groundBoundingRect
    }
    
    init() {
        super.init(name:"Ground")
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        //set graphics
        guard let mainScene = scene as? MainScene else {
            fatalError("mainscene needed to initiate sprite library")
        }
        spriteLibrary = mainScene.spriteLibrary
        canvas.setup(spriteLibrary)
        
        guard let scene = scene as? MainScene else {
            fatalError("MainScene is needed for Ground setup")
        }
        groundBoundingRect.size.width = canvasSize.width
        sprite.size.width = canvasSize.width
        groundBoundingRect.topLeft.y = scene.groundLevel
        let groundRectangle = Rectangle(rect: groundBoundingRect, fillMode:.stroke)
        canvas.render(groundRectangle)
    }
    
    override func render(canvas: Canvas) {
        let groundRectangle = Rectangle(rect: groundBoundingRect, fillMode:.stroke)
        canvas.render(groundRectangle)

        //sprite render
        if spriteLibrary.isReady {
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:sprite, destinationRect: groundBoundingRect)
            canvas.render(spriteLibrary)
        }
    }
}
