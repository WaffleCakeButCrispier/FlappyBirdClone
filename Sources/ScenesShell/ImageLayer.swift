import Scenes
import Igis
import Foundation

class SpriteLayer : Layer {
    
    let spriteLibrary = SpriteLibrary()

    func returnSpriteLibrary() -> Image? {
        spriteLibrary.returnSpriteLibrary()
    }
    
    init() {
        super.init(name:"SpriteLayer")
        insert(entity: spriteLibrary, at:.back)
    }
}
