import Scenes
import Igis

class RefreshLayer : Layer {
    
    let refresh = Refresh()
    
    init() {
        super.init(name:"RefreshLayer")
        insert(entity: refresh, at:.front)
    }
}
