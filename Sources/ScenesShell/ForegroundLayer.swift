import Scenes
import Igis
  /*
     This class is responsible for the foreground Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class ForegroundLayer : Layer {

    let ground = Ground()
    let playScreen = PlayScreen()
    let score = Score()    

    let debug = DebugMenu()
    //return rects
    func returnGroundRect() -> Rect {
        let rect = ground.returnGroundRect()
        return rect
    }
    
    //no life??? >.>
    func birdDeath() {
        score.resetScore()
    }

    //scored ¯\_(ツ)_/¯
    func birdScored() {
        score.birdScored()
    }

    
      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Foreground")
          
          // We insert our RenderableEntities in the constructor
          insert(entity: ground, at:.back)
          insert(entity: playScreen, at:.front)
          insert(entity: score, at:.front)

          insert(entity: debug, at:.front)
      }
}

