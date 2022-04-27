import Igis
import Scenes

class PlayScreen : RenderableEntity, EntityMouseClickHandler {
    //Event States
    var isActive = true
        
    //Visuals
    let text = Text(location: Point(x: 50,y: 50), text: "click to FLY!!!")
    
    //attributes
        
    //events
    func onEntityMouseClick(globalLocation:Point) {
        guard let scene = scene as? MainScene else {
            fatalError("main scene is needed for PlayScreen")
        }
        
        if scene.playable && scene.spriteLibraryReady {
            scene.reset = false
            isActive = false
            scene.playing = true
        }
        
    }

    func birdDeath() {
        isActive = true
    }

    override func calculate(canvasSize: Size) {
    }
    
    init() {
        super.init(name:"PlayScreen")
    }
    //define boundingrect for click
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
    
    override func setup(canvasSize:Size, canvas:Canvas) {
        text.location = canvasSize.center
        text.font = "20pt M"
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }

    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed for PlayScreen render")
        }

        //wait until sprites have loaded
        if !scene.spriteLibraryReady {
            text.text = "loading sprites..."
        } else {
            text.text = "click to FLY!!!"
        }
        
        guard let scene = scene as? MainScene else {
            fatalError("main scene is needed for PlayScreen")
        }

        if isActive && scene.playable {
            canvas.render(text)
        }

        if scene.reset {
            isActive = true
        }
    }
}
