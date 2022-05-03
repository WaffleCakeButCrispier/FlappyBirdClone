import Igis
import Scenes
import Foundation

class Obstacle : RenderableEntity {
    //Event States
    var isActive = false //are you in a playable state? 
    var resetable = false //are you resetable?

    //Visuals
    //Bounding Rects
    var obstacleBoundingRectBottom = Rect(topLeft:Point(x:500,y:0), size:Size(width: 130, height: 0)) 
    var obstacleBoundingRectTop = Rect(topLeft:Point(x:500,y:0), size:Size(width: 130, height: 0)) 

    var pointBoundingRect = Rect(topLeft:Point(x: 500,y: 0), size:Size(width:100, height: 100))
    
    //sprite
    var spriteLibrary : Image = Image(sourceURL: URL(string:"placeholder")!)
    var spriteTop : Rect = Rect(topLeft:Point(x:663,y:150), size:Size(width:78, height:600)) 
    var spriteBottom : Rect = Rect(topLeft:Point(x:585,y:150), size:Size(width:78, height:600))
    
    //Position
    var yPos = 0
    var xPos = 0

    var returnPosX = 0
    var returnPosY = 0
    
    var spacing = 250 //spacing of obstacles (vertically)
    //Velocity
    var xVelocity : Double = 0
    var yVelocity : Double = 0
    
    //attributes
    var number = 0
    
    var startVelocity : Double = 0.0
    var difficulty : Double = 1.0

    var oscillating = false //is obstacle moving up and down?
    
    var scored = false //have you scored?
    
    //return rect :eyes:
    func returnRect() -> Rect {
        let rect = obstacleBoundingRectBottom
        return rect
    }

    //move up and down
    var hardMode = false
    
    
    var amountMoved = 0
    var movementAmount = Int.random(in: -1000 ..< 1000)
    var movementCheck = 0
    
    func moveUpAndDown() {
        print(movementAmount)
        //test to see if in range
        while abs(movementAmount) - 20 < 0 {
            movementAmount = Int.random(in: -1000 ..< 1000)
            print("not in range")
        }
        
        if movementAmount < 0 {
            if abs(movementAmount) > obstacleBoundingRectTop.height{
                movementCheck = 0
            } else {
                movementCheck = -5
            }
        }

        else if movementAmount > 0 {
            if abs(movementAmount) > obstacleBoundingRectBottom.height {
                movementCheck = 0
            } else {
                movementCheck = 5
            }
        }

        obstacleBoundingRectTop.topLeft.y += movementCheck
        obstacleBoundingRectBottom.topLeft.y += movementCheck
        pointBoundingRect.topLeft.y += movementCheck
        amountMoved += 5

        if amountMoved > abs(movementAmount) {
            amountMoved = -amountMoved
            movementCheck = -movementCheck
        }
    }
            
            
     
    //move to specified point
    func move(to point: Point) {
        obstacleBoundingRectBottom.topLeft = point
        
    }
    
    //offsets by specified dimensions 
    func offset(x: Int, y:Int) { 
        xPos += x
        yPos += y
    }

    func offsetReturn(x:Int, y:Int) {
        returnPosX += x
        returnPosY += y
    }

    //set return position
    func returnPos(x:Int, y:Int) {
        returnPosX = x
        returnPosY = y
    }
    
    //reset after bird dies
    func resetPos() {
        yPos = returnPosY - Int.random(in:100 ... 400) //randomize once reset
        xPos = returnPosX
    }

    override func calculate(canvasSize: Size) {
        guard let scene = scene as? MainScene else {
            fatalError("Main scene required for Obstacle")
        }
        
        //test to see if scene is resetting
        if scene.reset && resetable {
            scored = false
            resetPos()
            resetable = false
        }
        
        //test to see if player is playing
        if scene.playing {
            isActive = true
        }

        //test to see if player is dying
        if scene.isDying {
            isActive = false
        }
        
         //calculate only when the object is active
         if isActive && scene.playable {
             resetable = true //can be reset
             // calculate new positions
             xPos += Int(xVelocity)
             yPos += Int(yVelocity)
             
             //test for collision with respawn
             let obstacleDespawnRect = scene.returnDespawnRect() 
             let despawnContainmentBottom = obstacleDespawnRect.containment(target: obstacleBoundingRectBottom)
             if !despawnContainmentBottom.intersection([.contact]).isEmpty{
                 xPos += 4500
                 yPos = returnPosY
                 yPos -= Int.random(in:100 ... 400)
                 scored = false
             }
             
             //test for collision with bird
            let birdRect = scene.returnBirdRect()
            let birdDeathContainmentBottom = obstacleBoundingRectBottom.containment(target: birdRect)
            let birdDeathContainmentTop = obstacleBoundingRectTop.containment(target: birdRect)
            
            //test collision with ground
            let groundBoundingRect = scene.returnGroundRect()
            let birdGroundContainment = groundBoundingRect.containment(target: birdRect)

            //test for death 💀
            if !birdDeathContainmentBottom.intersection([.contact]).isEmpty || !birdDeathContainmentTop.intersection([.contact]).isEmpty || !birdGroundContainment.intersection([.contact]).isEmpty {
                scene.birdDeath()
                scene.playing = false
                isActive = false
            }

            //test collision with bird for point
            let birdPointContainment = pointBoundingRect.containment(target: birdRect)
            if !birdPointContainment.intersection([.contact]).isEmpty {
                if !scored {
                    scored = true
                    scene.birdScored()
                }
            }
         }
         //move rects to postion
         //bottom rect
         obstacleBoundingRectBottom.topLeft = Point(x:xPos, y:yPos)
         
         //top rect
         obstacleBoundingRectTop.topLeft = obstacleBoundingRectBottom.topLeft
         obstacleBoundingRectTop.topLeft.y = obstacleBoundingRectBottom.topLeft.y - obstacleBoundingRectTop.size.height - spacing

         //point rect
         pointBoundingRect.topLeft = obstacleBoundingRectBottom.topLeft
         pointBoundingRect.size.height = spacing
         pointBoundingRect.topLeft.y = obstacleBoundingRectBottom.topLeft.y - spacing
         pointBoundingRect.topLeft.x += obstacleBoundingRectBottom.size.width

         //update debug (/n means to move on to next section of data)
         scene.debugInformation.append("Obstacle \(number) Data: Position: topRect:(\(obstacleBoundingRectTop.topLeft.x),\(obstacleBoundingRectTop.topLeft.y)) - bottomRect:(\(obstacleBoundingRectBottom.topLeft.x),\(obstacleBoundingRectBottom.topLeft.y)) - pointRect:(\(pointBoundingRect.topLeft.x),\(pointBoundingRect.topLeft.y)), Velocity: (\(xVelocity),\(yVelocity)), Attributes: isActive:\(isActive) resetable:\(resetable) scored:\(scored)")
         if oscillating {
             moveUpAndDown()
         }
    }
    
    init() {
        super.init(name:"Obstacle")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        //set graphics
        guard let scene = scene as? MainScene else {
            fatalError("mainscene needed to initiate sprite library")
        }
        
        xPos += 1000
        yPos += scene.groundLevel
        returnPosX += xPos
        returnPosY = yPos
        startVelocity = scene.speed
        xVelocity = startVelocity * difficulty 
        yPos -= Int.random(in: 100 ... 450)

        //setup obstacle sizes
        obstacleBoundingRectBottom.size.height += 1000 //extend rect down a lot
        obstacleBoundingRectTop.topLeft.y += 1000 //move rect up a lot
        obstacleBoundingRectTop.size.height += 1000 //extend rect down a lot
    }
    
    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene needed for sprites for Obstacle")
        }
        
        //render bounding rects
        // let obstacleRectangleBottom = Rectangle(rect: obstacleBoundingRectBottom, fillMode: .stroke)
        // let obstacleRectangleTop = Rectangle(rect: obstacleBoundingRectTop, fillMode: .stroke)
        // let pointRectangle = Rectangle(rect: pointBoundingRect, fillMode: .stroke)
        // canvas.render(pointRectangle, obstacleRectangleBottom, obstacleRectangleTop)

        //sprite render
        if scene.spriteLibraryReady {
            spriteLibrary = scene.returnSpriteLibrary()!
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:spriteBottom, destinationRect: obstacleBoundingRectBottom)
            canvas.render(spriteLibrary)
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:spriteTop, destinationRect: obstacleBoundingRectTop)
            canvas.render(spriteLibrary)
        }
    }
}
