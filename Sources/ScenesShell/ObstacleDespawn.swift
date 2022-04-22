import Igis
import Scenes
import Foundation

class ObstacleDespawn : RenderableEntity {
    //Event States
    var isActive = true

    //Visuals
    var obstacleDespawnRect = Rect(topLeft:Point(x:0,y:0), size:Size(width: 50, height: 1000)) 
    //Position
    var yPos = 0
    var xPos = 0
    
    //Velocity
    var xVelocity : Double = 0
    var yVelocity : Double = 0
    
    //attributes
    

    //return rect :eyes:
    func returnRect() -> Rect {
        let rect : Rect = obstacleDespawnRect
        return rect
    }

    func move(to point: Point) {
        obstacleDespawnRect.topLeft = point
    }
    
    override func calculate(canvasSize: Size) {
        if isActive {
        // calculate new positions
            xPos += Int(xVelocity)
            yPos += Int(yVelocity)
        }
    }
    
    init() {
        super.init(name:"ObstacleDespawn")
    }

    override func setup(canvasSize: Size, canvas: Canvas) {
        obstacleDespawnRect.size.height = Int.max
        obstacleDespawnRect.topLeft.x -= obstacleDespawnRect.size.width + 100
    }

    override func render(canvas: Canvas) {
        let obstacleDespawnRectangle = Rectangle(rect: obstacleDespawnRect, fillMode: .stroke)
        canvas.render(obstacleDespawnRectangle)
    }
}
