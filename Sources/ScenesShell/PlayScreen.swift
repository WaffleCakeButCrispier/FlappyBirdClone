import Igis
import Scenes

class PlayScreen : RenderableEntity, EntityMouseClickHandler {
    //Event States
    var isActive = true
        
    //Visuals
<<<<<<< HEAD
    let text = Text(location: Point(x: 50,y: 50), text: "click to play")
=======
    let text = Text(location: Point(x: 50,y: 50), text: "click to FLY!!!")
>>>>>>> 9b85abb23874c10e9feb5367690431f37ecb908f
    
    //attributes
        
    //events
    func onEntityMouseClick(globalLocation:Point) {
        guard let scene = scene as? MainScene else {
            fatalError("main scene is needed for PlayScreen")
        }
        
        if scene.playable {
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
        dispatcher.registerEntityMouseClickHandler(handler:self)
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }

    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("main scene is needed for PlayScreen")
        }

        if isActive && scene.playable {
            canvas.render(text)
        }

        if scene.reset {
            isActive = true
            scene.reset = false
        }
    }
}
