import Igis
import Scenes
import Foundation

class PlayScreen : RenderableEntity, EntityMouseClickHandler {
    //Event States
    var isActive = true
        
    //Visuals
    let text = Text(location: Point(x: 50,y: 50), text: "click to FLY!!!")

    //sprite
    var spriteLibrary : Image = Image(sourceURL: URL(string:"Placeholder")!)

    var jumpRect : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:150,height:105)) 
    var jumpSprite  : Rect = Rect(topLeft:Point(x:586,y:754), size:Size(width:97,height:67)) 
    var jumpBlinkSprite  : Rect = Rect(topLeft:Point(x:715,y:754), size:Size(width:97,height:67)) 

    var playRect : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:150,height:105)) 
    var playSprite  : Rect = Rect(topLeft:Point(x:586,y:823), size:Size(width:97,height:67)) 
    var playBlinkSprite  : Rect = Rect(topLeft:Point(x:715,y:823), size:Size(width:97,height:67)) 

    var spriteState = 0
    //attributes
    var timeStep : Int = 5
    var time : Int = 0
    
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

        //center icons
        jumpRect.topLeft.x = canvasSize.center.x - jumpRect.size.width - 5
        jumpRect.topLeft.y = canvasSize.center.y - jumpRect.size.height

        playRect.topLeft.x = canvasSize.center.x + 5
        playRect.topLeft.y = canvasSize.center.y - playRect.size.height 
    }

    override func teardown() {
        dispatcher.unregisterEntityMouseClickHandler(handler:self)
    }

    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed for PlayScreen render")
        }
        
        if isActive && scene.playable && scene.spriteLibraryReady {
            spriteLibrary = scene.returnSpriteLibrary()!
            switch spriteState {
            case 0:
                if time < timeStep {
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:jumpSprite,destinationRect:jumpRect)
                    canvas.render(spriteLibrary)
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:playSprite,destinationRect:playRect)
                    canvas.render(spriteLibrary)
                    time += 1
                } else {
                    //will not render if not rendered for final time in cycle
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:jumpSprite,destinationRect:jumpRect)
                    canvas.render(spriteLibrary)
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:playSprite,destinationRect:playRect)
                    canvas.render(spriteLibrary)
                    time = 0
                    spriteState = 1
                }
            case 1:
                if time < timeStep {
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:jumpBlinkSprite,destinationRect:jumpRect)
                    canvas.render(spriteLibrary)
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:playBlinkSprite,destinationRect:playRect)
                    canvas.render(spriteLibrary)
                    time += 1
                } else {
                    //will not render if not rendered for final time in cycle
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:jumpBlinkSprite,destinationRect:jumpRect)
                    canvas.render(spriteLibrary)
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:playBlinkSprite,destinationRect:playRect)
                    canvas.render(spriteLibrary)
                    time = 0
                    spriteState = 0
                }
            default:
                break
            }
        }

        if scene.reset {
            isActive = true
        }
    }
}
