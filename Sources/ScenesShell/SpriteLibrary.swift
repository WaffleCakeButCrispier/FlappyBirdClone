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
        //initiate sprite library
        guard let spriteLibraryUrl = URL(string:"https://www.codermerlin.com/users/soohan-cho/images/SpriteSheet.FlappyBirdClone.ver.1.0.3(robotConversion)(highRes).png") else {
            fatalError("failed to load sprite library url")
        }
        spriteLibrary = Image(sourceURL: spriteLibraryUrl)
       
        super.init(name:"SpriteLibrary")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(spriteLibrary)
        print("setted the upped the sprite library")
    }

    override func calculate(canvasSize: Size) {
        guard let scene = scene as? MainScene else {
            fatalError("mainscene needed for spriteLibrary")
        }
        if spriteLibrary.isReady {
            scene.spriteLibraryReady = true
        } 
    }
}
