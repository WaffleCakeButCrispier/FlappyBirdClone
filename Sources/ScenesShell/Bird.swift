import Igis
import Scenes
import Foundation

class Bird : RenderableEntity, KeyDownHandler {
    //Event States
    var isActive = false //are you in a playable state?
    var isDying = false //are you *insert skull emoji*

    //Visuals
    var birdBoundingRect = Rect(topLeft:Point(x:0, y:0), size:Size(width: 50, height: 50))

    //sprite
    var spriteLibrary : Image = Image(sourceURL: URL(string:"placeholder")!)
    var sprite : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:50,height:50)) 
    
    //Position
    var yPos = 0
    var xPos = 0

    var returnPosX = 0
    var returnPosY = 0
    
    //Velocity
    var yVelocity : Double = 0
    var xVelocity : Double = 0
    
    var xLocked = true
    
    //attributes
    let fatness : Double = 1        //heheheheh
    var flapPower : Double = 10.0     //replaces yVelocity 
    
    //time
    let frameRate = 30                //frames per second 
    var timeCoefficient : Double = 0  //how fast is time?
    var time : Double = 0             //current cycle time
    var timeStep : Double = 0
    
    //environment
    let gravity : Double = 20 
    let wind : Double = 0.0

    func returnRect() -> Rect {
        let rect = birdBoundingRect
        return rect
    }

    func birdDeath() {
        isActive = false
        isDying = true
    }
    
    func reset() {
        yPos = returnPosY
        xPos = returnPosX
    }
    
    func play() {
        isActive = true
    }
    
    //key presses
    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if isActive {
            if key == "w" {
                yVelocity = -1 * flapPower
            }
            if !xLocked {
                switch key {
                case "ArrowLeft":
                    xPos -= 25
                case "ArrowRight":
                    xPos += 25
                default:
                    break
                }
            }
        }
    }
    
    init() {
        super.init(name:"Bird")
    }

    override func calculate(canvasSize: Size) {
        guard let scene = scene as? MainScene else {
            fatalError("mainScene required for birdy boi")
        }

        //play death animation
        if isDying {
            scene.playable = false
            if yPos < canvasSize.height + 500 {
                if time >= timeCoefficient {
                    yVelocity += gravity
                }
            } else {
                reset()
                scene.reset = true
                isDying = false
                scene.playable = true
            }
        }
        
        //test to see if player playing
        if scene.playing {
            isActive = true
        }
        
        // calculate new positions
        xPos += Int(xVelocity)
        yPos += Int(yVelocity)
        
        //wind
        if time >= timeCoefficient {
            xVelocity -= wind / Double(frameRate)
        } 
        
        //passive movement while in start screen
        if !isActive {
            yVelocity = 0
            xVelocity = 0
        }
        
        //gravity
        if time >= timeCoefficient {
            yVelocity += gravity / Double(frameRate)
        }

        //move bird to postion
        birdBoundingRect.topLeft = Point(x:xPos, y:yPos)
        
        //update time
        if time < timeCoefficient {
            time += 1
        } else {
            time = 0
        }
    }
    
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        //set graphics
        guard let mainScene = scene as? MainScene else {
            fatalError("mainscene needed to initiate sprite library")
        }
        spriteLibrary = mainScene.spriteLibrary
        canvas.setup(spriteLibrary)
                
        //ObEsItY FaCtoR
        birdBoundingRect.size.width = Int(Double(birdBoundingRect.size.width) * fatness)
        birdBoundingRect.size.height = Int(Double(birdBoundingRect.size.height) * fatness)

        flapPower = flapPower / fatness
        //setup
        yPos = canvasSize.center.y
        xPos = 250
        returnPosY = yPos
        returnPosX = xPos
        dispatcher.registerKeyDownHandler(handler:self)
    }

    override func render(canvas: Canvas) {
        //bird bounding rect render
        let birdRectangle = Rectangle(rect: birdBoundingRect, fillMode: .stroke)
        canvas.render(birdRectangle)

        //sprite render
        if spriteLibrary.isReady {
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:sprite, destinationRect: birdBoundingRect)
            canvas.render(spriteLibrary)
        }
        
    }
        
    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
}
