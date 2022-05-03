import Igis
import Scenes

class MouseEvents : RenderableEntity , EntityMouseClickHandler {
    func onEntityMouseClick(globalLocation:Point) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene required for MouseEvents")
        }
        scene.mouseClickEvent(globalLocation: globalLocation)
    }

    init() {
        super.init(name:"MouseEvents")
    }
    
    //define boundingrect for click
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
    
    //register entityMouseclickhandler
    override func setup(canvasSize:Size, canvas:Canvas) {
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }
    
    //unregisterEntityMouseClickhandler
    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }
   
}
