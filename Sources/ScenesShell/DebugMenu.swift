import Scenes
import Igis

class DebugMenu : RenderableEntity {

    var text = Text(location: Point(x:100,y:50), text:"") 
    
    init() {
        super.init(name: "DebugMenu")

    }

    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed for debugMenu")
        }
        //style
        text.font = "10pt Arial"
        let fillStyle = FillStyle(color:Color(.black))
        
        for element in scene.debugInformation {
            text.text = element
            //canvas.render(fillStyle, text)
            text.location.y += 11
        }
        
        //reset debug information
        scene.debugInformation = []
        text = Text(location: Point(x:100,y:50), text:"")  
    }
    
    
}
