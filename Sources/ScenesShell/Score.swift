import Igis
import Scenes

class Score : RenderableEntity {
    //Event States
    var isActive = false //are you in a playable state?

    //Visuals
    var textCurrentScore = Text(location:Point(x:100,y:100),text: "")
    var textHighScore = Text(location:Point(x:100,y:120),text: "")
    
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
        textCurrentScore.font = "20pt Comic sans"
        textHighScore.font = "20pt Comic sans"
        canvas.render(textCurrentScore, textHighScore)
    }
}
