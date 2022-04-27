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
<<<<<<< HEAD
    var spriteLibrary : Image = Image(sourceURL: URL(string:"Placeholder")!)
    var sprite : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:50,height:50)) 
    
=======
    var spriteLibrary : Image = Image(sourceURL: URL(string:"placeholder")!)
    var idleSprite : Rect = Rect(topLeft:Point(x:585,y:0), size:Size(width:150,height:150)) 
    var flapSprite : Rect = Rect(topLeft:Point(x:735,y:0), size:Size(width:150,height:150)) 

    var spriteState = 0
>>>>>>> 8dadfa116ff856e4c68c9ef1a392752cd6b8c2a6
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
    var orientation : Double = 0

    let fatness : Double = 1        //heheheheh
    var flapPower : Double = 14.25     //replaces yVelocity 
    
    //time
    let frameRate = 30                //frames per second 
    var timeCoefficient : Double = 0  //how fast is time?
    var time : Double = 0             //current cycle time
    var timeStep : Double = 0
    
    //environment
    let gravity : Double = 30 
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
            if key == "w" || key == "" {
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
        //test to see if player is too high
        if birdBoundingRect.topLeft.y <= -500 {
            scene.birdDeath()
            scene.playing = false
        }

        //test to see if player playing
        if scene.playing {
            scene.reset = false
            isActive = true
        }
        
        //play death animation
        if isDying {
            scene.playable = false
            scene.isDying = true
            if yPos < scene.groundLevel + 500 {
                yVelocity += gravity / Double(frameRate)
                xPos -= 5
            } else {
                reset()
                print("reset")
                scene.reset = true
                isDying = false
                scene.isDying = false
                scene.playable = true
            }
        }
        
        //passive movement while in start screen
        if !isActive && scene.playable {
            yVelocity = 0
            xVelocity = 0
        }
        
        // calculate new positions
        xPos += Int(xVelocity)
        yPos += Int(yVelocity)

        //wind
        if time >= timeCoefficient && isActive {
            xVelocity -= wind / Double(frameRate)
        } 
        
        //gravity
        if time >= timeCoefficient && isActive {
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

        //update debug (/n means to move on to next section of data)
        scene.debugInformation.append("Bird Data: position: (\(xPos),\(yPos)), velocity: (\(xVelocity),\(yVelocity)), States: isActive:\(isActive) isDying:\(isDying), Attributes: fatness:\(fatness) flapPower:(\(flapPower))")
    }
    
    override func boundingRect() -> Rect {
        return Rect(size: Size(width: Int.max, height: Int.max))
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        //set graphics
        guard let mainScene = scene as? MainScene else {
            fatalError("mainscene needed to initiate sprite library")
        }
                
        //ObEsItY FaCtoR
        birdBoundingRect.size.width = Int(Double(birdBoundingRect.size.width) * fatness)
        birdBoundingRect.size.height = Int(Double(birdBoundingRect.size.height) * fatness)

        flapPower = flapPower / fatness
        //setup
        yPos = canvasSize.center.y
        xPos = 550
        returnPosY = yPos
        returnPosX = xPos
        dispatcher.registerKeyDownHandler(handler:self)
    }

    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed for Bird render")
        }

        //bird bounding rect render
        let birdRectangle = Rectangle(rect: birdBoundingRect, fillMode: .stroke)
        canvas.render(birdRectangle)

        //sprite render
        if scene.spriteLibraryReady {
            spriteLibrary = scene.returnSpriteLibrary()!
            if yVelocity < 0 {
                switch spriteState {
                case 0:
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:flapSprite, destinationRect: birdBoundingRect)
                    spriteState = 1
                case 1:
                    spriteLibrary.renderMode = .sourceAndDestination(sourceRect:idleSprite, destinationRect: birdBoundingRect)
                    spriteState = 0
                default:
                    break
                }
            } else {
                spriteLibrary.renderMode = .sourceAndDestination(sourceRect:idleSprite, destinationRect: birdBoundingRect)
            }
            canvas.render(spriteLibrary)
        }
        
    }
        
    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }
}
