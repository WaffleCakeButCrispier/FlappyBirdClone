import Igis
import Foundation
import Scenes

class SpriteLibrary : RenderableEntity {
    //states
    var idChanged = false
      
    //visuals
    var spriteLibraryID = 0
    var spriteLibrary = Image(sourceURL: URL(string:"placeholder")!)

    let spriteLibraryURL = [
      "https://www.codermerlin.com/users/soohan-cho/images/SpriteSheet.FlappyBirdClone.ver.1.0.4_10.png",
      "https://www.codermerlin.com/users/soohan-cho/images/SpriteSheet.FlappyBirdClone.ver.1.0.3(robotConversion)(highRes).png",
      "https://www.atlasandboots.com/wp-content/uploads/2019/05/ama-dablam2-most-beautiful-mountains-in-the-world.jpg",
      "https://www.codermerlin.com/users/soohan-cho/images/SpriteSheet.FlappyBirdClone.ver.1.0.5(hyperRealistic).png",
      "http://images6.fanpop.com/image/photos/33100000/Random-ASCII-ascii-art-33172340-1405-984.png",
      "https://designshack.net/wp-content/uploads/fractal-art.jpg",
      "https://www.leafie.co.uk/wp-content/uploads/2021/11/fractal.jpeg",
      "https://staticg.sportskeeda.com/editor/2022/04/ab2a0-16492353149125-1920.jpg",
      "https://codermerlin.com/users/soohan-cho/images/Untitled%20presentation.png"
    ]
    
    func returnSpriteLibrary() -> Image? {
        if spriteLibrary.isReady {
            return spriteLibrary
        } else {
            print("not ready to sprite yet")
            return nil
        }
    }

    func changeID(id: Int) {
        spriteLibraryID = id
        idChanged = true
    }
    
    init() {
        super.init(name:"SpriteLibrary")
    }
    
    func keyDownEvent(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        guard let scene = scene as? MainScene else {
            fatalError("MainScene required for spriteLibrary keyDownEvent")
        }
        switch key {
        case "d" :
            if spriteLibraryID < spriteLibraryURL.count - 1 {
                spriteLibraryID += 1
            } else {
                spriteLibraryID = 0 
            }
            idChanged = true
            scene.spriteLibraryReady = false
        case "a":
            if spriteLibraryID > 0 {
                spriteLibraryID -= 1
            } else {
                spriteLibraryID = spriteLibraryURL.count - 1 
            }
            idChanged = true
            scene.spriteLibraryReady = false
        default:
            break
        }
    }
    
    override func setup(canvasSize: Size, canvas: Canvas) {
        for element in spriteLibraryURL {
            let spriteURL = URL(string:"\(element)")
            spriteLibrary = Image(sourceURL: spriteURL!)
            canvas.setup(spriteLibrary)
        }
        
        guard let spriteLibraryDefault = URL(string:"https://www.codermerlin.com/users/soohan-cho/images/SpriteSheet.FlappyBirdClone.ver.1.0.4_10.png") else {
            fatalError("failed to load sprite library url")
        }
        spriteLibrary = Image(sourceURL: spriteLibraryDefault)
        canvas.setup(spriteLibrary)
        
        print("setted the upped the sprite library")
    }

    override func render(canvas: Canvas) {
        guard let scene = scene as? MainScene else {
            fatalError("mainscene needed for spriteLibrary")
        }
        
        if idChanged {
            switch spriteLibraryID {
            case 0:
                guard let spriteLibraryDefault = URL(string:"https://www.codermerlin.com/users/soohan-cho/images/SpriteSheet.FlappyBirdClone.ver.1.0.4_10.png") else {
                    fatalError("failed to load sprite library url")
                }
                spriteLibrary = Image(sourceURL: spriteLibraryDefault)
                canvas.setup(spriteLibrary)
            default:
                guard let newSpriteURL = URL(string:"\(spriteLibraryURL[spriteLibraryID])") else {
                    fatalError("failed to load sprite library url")
                }
                spriteLibrary = Image(sourceURL: newSpriteURL)
                canvas.setup(spriteLibrary)
            }
            print("spriteLibrary id was changed")
            idChanged = false
        }
        if spriteLibrary.isReady {
            scene.spriteLibraryReady = true
        }
    }
}
