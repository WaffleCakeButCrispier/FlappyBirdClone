import Scenes
import Igis
  /*
     This class is responsible for the foreground Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class ForegroundLayer : Layer {
    //Interactables
    let ground = Ground()
    let playScreen = PlayScreen()
    let score = Score()    

    //Visuals
    let title = Title()
    
    let debug = DebugMenu()

    //event functions
    func mouseClickEvent(globalLocation: Point) {
        playScreen.mouseClickEvent(globalLocation: globalLocation)
    }

    func keyDownEvent(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        playScreen.keyDownEvent(key:key, code:code, ctrlKey:ctrlKey, shiftKey:ctrlKey, altKey:altKey, metaKey:metaKey)
    }
    
    //functions
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

          insert(entity: title, at:.front)
          
          insert(entity: debug, at:.front)
      }
}

