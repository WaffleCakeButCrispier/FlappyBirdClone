import Igis
import Scenes

class KeyPressEvents : RenderableEntity, KeyDownHandler {
    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene required for MouseEvents")
        }
        scene.keyDownEvent(key:key, code:code, ctrlKey:ctrlKey, shiftKey:ctrlKey, altKey:altKey, metaKey:metaKey)
    }

    init() {
        super.init(name:"KeyPressEvents")
    }
    
    //register entityMouseclickhandler
    override func setup(canvasSize:Size, canvas:Canvas) {
        dispatcher.registerKeyDownHandler(handler:self)
    }
    
    //unregisterEntityMouseClickhandler
    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
}
