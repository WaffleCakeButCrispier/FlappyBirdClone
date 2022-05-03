import Scenes
import Igis
import Foundation

class Title : RenderableEntity {
    //visuals
    var titleBoundingRect = Rect(topLeft: Point(x:10, y:10), size:Size(width: 291, height:87))
    
    var spriteLibrary : Image = Image(sourceURL: URL(string:"placeholder")!)
    var sprite : Rect = Rect(topLeft:Point(x:585,y:909), size:Size(width:291,height:87)) 
    
    init() {
        super.init(name:"Title")
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        //blank for now ;)
    }
    
    override func render(canvas:Canvas) {
        //setup Sprites
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed to setup sprites for Background")
        }

        if scene.spriteLibraryReady {
            spriteLibrary = scene.returnSpriteLibrary()!
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:sprite, destinationRect:titleBoundingRect)
            canvas.render(spriteLibrary)
        }
    }
}
