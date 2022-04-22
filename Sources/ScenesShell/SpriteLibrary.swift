import Igis
import Foundation
import Scenes

class SpriteLibrary : RenderableEntity {

    var spriteLibrary : Image

    func returnSpriteLibrary() -> Image? {
        if spriteLibrary.isReady {
            return spriteLibrary
        } else {
            print("not ready to sprite yet")
            return nil
        }
    }
    
    init() {
        super.init(name: "SpriteLibrary")
        guard let scene = scene as? MainScene else {
            fatalError("mainscene needed for spriteLibrary")
        }
        //initiate sprite library
        guard let spriteLibraryUrl = URL(string:scene.spriteLibraryURL) else {
            fatalError("failed to load sprite library url")
        }
        spriteLibrary = Image(sourceURL: spriteLibraryUrl)
        
        
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(spriteLibrary)
        print("setted the upped the sprite library")
    }
}
