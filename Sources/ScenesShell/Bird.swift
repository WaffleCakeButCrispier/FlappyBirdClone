import Igis
import Scenes
import Foundation

class Bird : RenderableEntity {
    //Event States
    var isActive = false //are you in a playable state?
    var isDying = false //are you *insert skull emoji*

    //Visuals
    var birdBoundingRect = Rect(topLeft:Point(x:0, y:0), size:Size(width: 70, height: 70))
    
    //sprite
    var spriteLibrary : Image = Image(sourceURL: URL(string:"Placeholder")!)
    var idleSprite : Rect = Rect(topLeft:Point(x:585,y:0), size:Size(width:150,height:150)) 
    var flapSprite : Rect = Rect(topLeft:Point(x:735,y:0), size:Size(width:150,height:150)) 
    
    var spriteState = 0
    //Position
    var yPos = 0
    var xPos = 0

    var returnPosX = 0
    var returnPosY = 0

    //orientation
    var orientation : Double = 0
    var rotationRadians = 0.0

    //Velocity
    var yVelocity : Double = 0
    var xVelocity : Double = 0
    
    var xLocked = true
    
    //attributes
    let fatness = 1.0        //heheheheh
    var flapPower = 14.25     //replaces yVelocity
    
    //time
    let frameRate = 30                //frames per second 
    var timeCoefficient : Double = 0  //how fast is time?
    var time : Double = 0             //current cycle time
    var timeStep : Double = 0
    
    //environment
    let gravity : Double = 30 
    let wind : Double = 0
    
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
        rotationRadians = 0
    }
    
    func play() {
        isActive = true
    }

    //when mouse is pressed
    func mouseClickEvent(globalLocation: Point) {
        if isActive {
            yVelocity = -1 * flapPower
        }
    }

    //when key is pressed
    func keyDownEvent(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if isActive {
            if key == "w" || key == "" {
                yVelocity = -1 * flapPower
            }
            if !xLocked {
                switch key {
                case "ArrowLeft":
                    if abs(xVelocity) < flapPower {
                        xVelocity -= 3
                    }
                case "ArrowRight":
                    if abs(xVelocity) < flapPower {
                        xVelocity += 3
                    }
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
        
        //rotate bird depending on yVelocity
        if !isDying {
            rotationRadians = yVelocity * Double.pi / 180.0
        }
        
        //play death animation
        if isDying {
            rotationRadians -= 15.0 * Double.pi / 180.0
            if rotationRadians > 2.0 * Double.pi {
                rotationRadians = 0.0
            }
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
         //ObEsItY FaCtoR
        birdBoundingRect.size.width = Int(Double(birdBoundingRect.size.width) * fatness)
        birdBoundingRect.size.height = Int(Double(birdBoundingRect.size.height) * fatness)

        flapPower = flapPower / fatness
        //setup
        yPos = canvasSize.center.y
        xPos = 550
        returnPosY = yPos
        returnPosX = xPos
    }

    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed for Bird render")
        }

        //bird bounding rect render
        // let birdRectangle = Rectangle(rect: birdBoundingRect, fillMode: .stroke)
        // canvas.render(birdRectangle)

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

            // Apply rotation transform
            let targetCenter = birdBoundingRect.center
            let preTranslate = Transform(translate:DoublePoint(targetCenter))
            let rotationTransform = Transform(rotateRadians:rotationRadians)
            let postTranslate = Transform(translate:DoublePoint(-targetCenter))
            setTransforms(transforms:[preTranslate, rotationTransform, postTranslate])

            canvas.render(spriteLibrary)
        }
    }
}
