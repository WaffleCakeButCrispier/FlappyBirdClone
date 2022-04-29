import Igis
import Scenes

class Score : RenderableEntity {
    //Event States
    var isActive = false //are you in a playable state?

    //Visuals
    var textCurrentScore = Text(location:Point(x:100,y:100),text: "")
    var textHighScore = Text(location:Point(x:100,y:120),text: "")

    var newHighScore = Text(location:Point(x:100,y:120),text:"NEW HIGH SCORE!")
    //attributes
    var currentScore = 0
    var highScore = 0

    let newHighScoreDuration = 50
    var time = 0
    //reset score
    func resetScore() {
        if highScore < currentScore {
            highScore = currentScore
            time = 50
        }
        currentScore = 0
    }
        
    //bird gained point
    func birdScored() {
        currentScore += 1
    }
    
    override func calculate(canvasSize:Size) {
        //make text our current Score
        textCurrentScore.text = "\(currentScore)"
        textHighScore.text = "\(highScore)"
    }
    
    init() {
        super.init(name:"Score")
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        textCurrentScore.location.x = canvasSize.center.x
        
        textHighScore.location.x = canvasSize.center.x + 3
        textHighScore.location.y += 10

        newHighScore.location = textHighScore.location
        newHighScore.location.x += 20

        textCurrentScore.font = "20pt Arial"
        textHighScore.font = "10pt Arial"
        newHighScore.font = "10pt Arial"
        var fillStyle = FillStyle(color:Color(.black))
        canvas.render(fillStyle, textCurrentScore, textHighScore)
        fillStyle = FillStyle(color:Color(.black))
    }
    
    override func render(canvas: Canvas) {
        //render newHighScore
        if time > 0 {
            canvas.render(newHighScore)
            time -= 1
        }
        
        var fillStyle = FillStyle(color:Color(.black))
        canvas.render(fillStyle, textCurrentScore, textHighScore)
        fillStyle = FillStyle(color:Color(.black))
    }
}
