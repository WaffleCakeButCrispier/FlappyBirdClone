import Igis
import Scenes

class EventHandlerLayer : Layer {
    let mouseEvents = MouseEvents()
    let keyEvents = KeyPressEvents()
    
    init() {
        super.init(name:"EventHandlerLayer")
        insert(entity:keyEvents, at:.front)
        insert(entity:mouseEvents, at:.front)
    }
    
}
