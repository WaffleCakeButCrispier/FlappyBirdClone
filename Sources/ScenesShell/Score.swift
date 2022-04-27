import Igis
import Scenes

class Score : RenderableEntity {
    //Event States
    var isActive = false //are you in a playable state?

    //Visuals
    var textCurrentScore = Text(location:Point(x:100,y:100),text: "")
    var textHighScore = Text(location:Point(x:100,y:120),text: "")
    let scoreBorderRect = Rect(topLeft:Point(x:90, y:75), size:Size(width:250, height:50))
    
    //attributes
    var currentScore = 0
    var highScore = 0

    //reset score
    func resetScore() {
        if highScore < currentScore {
            highScore = currentScore
        }
        currentScore = 0
    }
        
    //bird gained point
    func birdScored() {
        currentScore += 1
    }
    
    override func calculate(canvasSize:Size) {
        //make text our current Score
        textCurrentScore.text = ""
        textHighScore.text = ""
        textCurrentScore.text += "CurrentScore : \(currentScore)"
        textHighScore.text += "HighScore : \(highScore)"
    }
    
    init() {
        super.init(name:"Score")
    }
    
    override func render(canvas: Canvas) {
        let scoreBorderRectangle = Rectangle(rect:scoreBorderRect, fillMode:.fillAndStroke)
        var strokeStyle = StrokeStyle(color:Color(.black))
        var fillStyle = FillStyle(color:Color(.orange))
        textCurrentScore.font = "20pt Press Start"
        textHighScore.font = "20pt 2P Press Start"

        canvas.render(strokeStyle, fillStyle, scoreBorderRectangle)
        strokeStyle = StrokeStyle(color:Color(.black))
        fillStyle = FillStyle(color:Color(.white))
        canvas.render(strokeStyle, fillStyle, textCurrentScore, textHighScore)
        fillStyle = FillStyle(color:Color(.black))
    }
}
