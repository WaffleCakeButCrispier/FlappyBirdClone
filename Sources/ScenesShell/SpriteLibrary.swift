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
        guard let spriteLibraryUrl = URL(string:"https://www.thoughtco.com/thmb/Zya6PS3m6XjRAmVo1HONvY9DW_A=/3865x2174/smart/filters:no_upscale()/abstract-paper-flower-pattern-656688606-5acfba2eae9ab80038461ca0.jpg") else {
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
