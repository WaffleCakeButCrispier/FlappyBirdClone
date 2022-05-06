import Scenes
import Igis
import Foundation

class DebugMenu : RenderableEntity {
    //keypress information
    var spriteLibrary : Image = Image(sourceURL: URL(string:"Placeholder")!)

    var jumpRect : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:150,height:105)) 
    var jumpSprite  : Rect = Rect(topLeft:Point(x:586,y:754), size:Size(width:97,height:67)) 
    var jumpBlinkSprite  : Rect = Rect(topLeft:Point(x:715,y:754), size:Size(width:97,height:67)) 
    var currentJumpSprite : Rect = Rect(topLeft:Point(x:586,y:754), size:Size(width:97,height:67)) 
    
    var playRect : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:150,height:105)) 
    var playSprite : Rect = Rect(topLeft:Point(x:586,y:823), size:Size(width:97,height:67)) 
    var playBlinkSprite : Rect = Rect(topLeft:Point(x:715,y:823), size:Size(width:97,height:67)) 
    var currentPlaySprite : Rect = Rect(topLeft:Point(x:586,y:823), size:Size(width:97,height:67)) 

    var blinkTime = 0
    let blinkHold = 2
    
    //var information    
    var text = Text(location: Point(x:10,y:110), text:"") 
    
    init() {
        super.init(name: "DebugMenu")

    }

    func mouseClickEvent(globalLocation: Point) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene required for mouseClickEvent in PlayScreen")
        }
        currentPlaySprite = playBlinkSprite
        blinkTime = blinkHold
    }
    
    func keyDownEvent(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene required for mouseClickEvent in PlayScreen")
        }
        
        if key == "w" {
            currentJumpSprite = jumpBlinkSprite
            blinkTime = blinkHold
        }
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        //move keypresses to position
        jumpRect.topLeft.x = 10
        jumpRect.topLeft.y = 10

        playRect.topLeft.x = playRect.size.width + 20
        playRect.topLeft.y = 10
    }
    
    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed for debugMenu")
        }
        
        if scene.debugMode == true {
            if scene.spriteLibraryReady {
                spriteLibrary = scene.returnSpriteLibrary()!
                spriteLibrary.renderMode = .sourceAndDestination(sourceRect:currentJumpSprite,destinationRect:jumpRect)
                canvas.render(spriteLibrary)
                spriteLibrary.renderMode = .sourceAndDestination(sourceRect:currentPlaySprite,destinationRect:playRect)
                canvas.render(spriteLibrary)
                if blinkTime == 0 {
                    currentJumpSprite = jumpSprite
                    currentPlaySprite = playSprite
                } else {
                    blinkTime -= 1
                }
            }
        
            //style
            text.font = "10pt Arial"
            let fillStyle = FillStyle(color:Color(.black))
            
            for element in scene.debugInformation {
                text.text = element
                canvas.render(fillStyle, text)
                text.location.y += 11
            }
            
            //reset debug information
            scene.debugInformation = []
            text = Text(location: Point(x:10,y:130), text:"")
        }
    }
}
