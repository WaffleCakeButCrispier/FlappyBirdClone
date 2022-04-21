import Igis
import Scenes
import Foundation

class Obstacle : RenderableEntity {
    //Event States
    var isActive = false //are you in a playable state? 

    var resetable = false //are you resetable?
    //Visuals
    //Bounding Rects
    var obstacleBoundingRectBottom = Rect(topLeft:Point(x:500,y:0), size:Size(width: 130, height: 100)) 
    var obstacleBoundingRectTop = Rect(topLeft:Point(x:500,y:0), size:Size(width: 130, height: 100)) 

    var pointBoundingRect = Rect(topLeft:Point(x: 500,y: 0), size:Size(width:100, height: 100))
    
    //sprite
    var spriteLibrary : Image = Image(sourceURL: URL(string:"placeholder")!)
    var spriteTop : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:130, height:1000))
    var spriteBottom : Rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:130, height:1000)) 
    
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
    var startVelocity : Double = 0.0
    var difficulty : Double = 1.0

    var scored = false //have you scored?
    //debug functions
    func returnVariable(vInt: Int?, vDouble: Double?) -> Double {
        if vInt != nil {
            return Double(vInt!)
        }
        if vDouble != nil {
            return vDouble!
        }
        return 0.0
    }
    
    //return rect :eyes:
    func returnRect() -> Rect {
        let rect = obstacleBoundingRectBottom
        return rect
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
        yPos = returnPosY - Int.random(in:0 ... 250) //randomize once reset
        xPos = returnPosX
    }

    override func calculate(canvasSize: Size) {
         guard let scene = scene as? MainScene else {
             fatalError("Main scene required for Obstacle")
         }
         
         //test to see if player is playing
         if scene.playing {
             isActive = true
         }
          
         //test to see if scene is resetting
         if scene.reset && resetable {
             isActive = false
             resetPos()
             resetable = false
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
                 yPos -= Int.random(in:0 ... 350)
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
         obstacleBoundingRectBottom.size.height += 10000 //extend rect down a lot
         //top rect
         obstacleBoundingRectTop.topLeft = obstacleBoundingRectBottom.topLeft
         obstacleBoundingRectTop.topLeft.y += 1000 //move rect up a lot
         obstacleBoundingRectTop.size.height += 1000 //extend rect down a lot
         obstacleBoundingRectTop.topLeft.y = obstacleBoundingRectBottom.topLeft.y - obstacleBoundingRectTop.size.height - spacing
         //point rect
         pointBoundingRect.topLeft = obstacleBoundingRectBottom.topLeft
         pointBoundingRect.size.height = spacing
         pointBoundingRect.topLeft.y = obstacleBoundingRectBottom.topLeft.y - spacing
         pointBoundingRect.topLeft.x += obstacleBoundingRectBottom.size.width
    }
    
    init() {
        super.init(name:"Obstacle")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        //set graphics
        guard let scene = scene as? MainScene else {
            fatalError("mainscene needed to initiate sprite library")
        }
        spriteLibrary = scene.spriteLibrary
        canvas.setup(spriteLibrary)
                
        xPos += 1000
        yPos += scene.groundLevel - obstacleBoundingRectBottom.size.height  
        returnPosX += xPos
        returnPosY = yPos
        startVelocity = scene.speed
        xVelocity = startVelocity * difficulty 
        yPos -= Int.random(in: 0 ... 250)
    }
    
    override func render(canvas: Canvas) {
        //render bounding rects
        let obstacleRectangleBottom = Rectangle(rect: obstacleBoundingRectBottom, fillMode: .stroke)
        let obstacleRectangleTop = Rectangle(rect: obstacleBoundingRectTop, fillMode: .stroke)
        let pointRectangle = Rectangle(rect: pointBoundingRect, fillMode: .stroke)
        canvas.render(pointRectangle, obstacleRectangleBottom, obstacleRectangleTop)

        //sprite render
        if spriteLibrary.isReady {
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:spriteBottom, destinationRect: obstacleBoundingRectBottom)
            canvas.render(spriteLibrary)
            spriteLibrary.renderMode = .sourceAndDestination(sourceRect:spriteTop, destinationRect: obstacleBoundingRectTop)
            canvas.render(spriteLibrary)
        }
    }
}
