import Scenes
import Igis
import Foundation

class InteractionLayer : Layer {

    let bird = Bird()
    let obstacleDespawn = ObstacleDespawn() 

    //event functions
    func mouseClickEvent(globalLocation: Point) {
        bird.mouseClickEvent(globalLocation: globalLocation)
    }

    func keyDownEvent(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        bird.keyDownEvent(key:key, code:code, ctrlKey:ctrlKey, shiftKey:ctrlKey, altKey:altKey, metaKey:metaKey)
    }
    
    //functions
    //return position of rect
    func returnDespawnRect() -> Rect {
        let rect : Rect = obstacleDespawn.returnRect()
        return rect
    }

    //return pos of bird
    func returnBirdRect() -> Rect {
        let rect : Rect = bird.returnRect()
        return rect
    }
    
    //bird died
    func birdDeath() {
        bird.birdDeath()
    }
    
    func spawnObstacles() {
        for index in 0 ..< 10 {
            //space between obstacles
            let offsetSpace = 450
            //define obstacles
            let obstacle = Obstacle()
                        
            //offset obstacles (in x) according to index
            obstacle.offset(x:offsetSpace * (index + 1),y:0)
                        
            //insert obstacles into scene
            insert(entity:obstacle, at:.back)
            obstacle.number = index
        }
    }
    
    init() {
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")
        
        // We insert our RenderableEntities in the constructor
        insert(entity:bird, at:.front)
        insert(entity:obstacleDespawn, at:.back)
        spawnObstacles()
    }
}
