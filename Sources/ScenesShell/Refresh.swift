import Igis
import Scenes

class Refresh : RenderableEntity {
    init() {
        super.init(name: "Refresh")
    }

    override func render(canvas:Canvas) {
        let clearRect = Rect(topLeft:Point(x:0, y:0), size:canvas.canvasSize!)
        let clearRectangle = Rectangle(rect:clearRect, fillMode:.clear)
        canvas.render(clearRectangle)
    }
}
