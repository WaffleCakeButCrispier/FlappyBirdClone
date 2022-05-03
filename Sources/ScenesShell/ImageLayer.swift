import Scenes
import Igis
import Foundation

class SpriteLayer : Layer {
    
    let spriteLibrary = SpriteLibrary()

    func returnSpriteLibrary() -> Image? {
        spriteLibrary.returnSpriteLibrary()
    }

    func keyDownEvent(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        spriteLibrary.keyDownEvent(key:key, code:code, ctrlKey:ctrlKey, shiftKey:ctrlKey, altKey:altKey, metaKey:metaKey)
    }
    
    
    init() {
        super.init(name:"SpriteLayer")
        insert(entity: spriteLibrary, at:.back)
    }
}
