import AppKit
import PlaygroundSupport
import SpriteKit

let dispatch = DispatchQueue(label: "test")

class view: NSViewController, NSTextFieldDelegate{
    // init the scene and the skview in which it will reside
    var skview: SKView?
    var scene: SKScene?
    
    // prepare the dimens for the window frame
    let frame = NSRect(x: 0, y: 0, width: 800, height: 650)
    
    var backgroundNode = SKSpriteNode(color: NSColor.clear, size: CGSize(width: 800, height: 650))
    
    var startGame = SKSpriteNode(color: NSColor.clear, size: CGSize(width: 800, height: 650))
    
    var gameOverLabel = SKLabelNode(text: "Game Over!")
    // an array of filenames referring to the images used for the circles
    let circleColours = ["circle.png", "circleBrown.png","circleDarkBlue.png","circleGreen.png","circleLightBlue.png","circleOrange.png","circlePink.png","circlePurple.png","circleRed.png","circleYellow.png"]
    
    // These two arrays control what is on the screen. If the user enters the correct colour, the first item in each array is removed.
    var colourArray = [String]()
    var spriteArray = [String]()
    
    // a count of the amount of circles the user has correctly guessed
    var circleCount = 0
    // The length of time between circle spawns. Decreases every 5 circles by 500 000 microseconds
    var circleGapSpeed = 6000000
    
    // the amount of lives the user has left. Max of 3.
    var livesRemaining = 3
    
    // the textbox allows the user to enter the letter they are trying to find
    let textBox = NSTextField(frame: NSRect(x: 143, y: 8, width: 225, height: 50))
    
    // the label shows the user what letter they should enter
    let letterLabel = SKLabelNode(text: "Colour: ")
    let livesLabel = SKLabelNode(text: "Lives: ")
    
    let letterNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 425, height: 100), cornerRadius: 10)
    let livesNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 400, height: 100), cornerRadius: 10)
    
    var addedHUD = false
    
    let titleLabel = SKLabelNode(text: "Welcome to Circle Time")
    let subtitleLabel = SKLabelNode(text: "A game about colour and fast typing!")
    let descriptionLabel = SKLabelNode(text: "Enter the name of the outermost circle and press Return before it gets too big! Colour names are all lower-case.")
    
    let gameScoreLabel = SKLabelNode(text: "Score: ")
    let gameScoreNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 100), cornerRadius: 10)
    
    // a font for the all SKLabelNodes
    let letterFont: NSFont = NSFont(name: "Arial", size: 40)!
    // A separate font for the Game Start and Game Over text
    let gameFont: NSFont = NSFont(name: "Arial", size: 80)!
    // A font for start and game over buttons
    let buttonFont: NSFont = NSFont(name: "Arial", size: 19)!
    
    let lightBlueLabel = SKLabelNode(text: "light blue")
    let darkBlueLabel = SKLabelNode(text: "dark blue")
    
    var restart = false
    
    // SKActions used by the circle
    let width = SKAction.resize(toWidth: 1500, duration: 10)
    let height = SKAction.resize(toHeight: 1500, duration: 10)
    
    let fadeToBlack = SKAction.colorize(with: NSColor(calibratedRed: 0.3, green: 0.3, blue: 0.3, alpha: 0.75), colorBlendFactor: 1, duration: 1)
    // a dispatch queue to run code in the background
    let dispatchQueue = DispatchQueue(label: "animation")
    
    override func loadView() {
        //print("Loading view")
        // use the frame created above to create the main view
        self.view = NSView(frame: frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("did load")
        view.frame = frame
        view.wantsLayer = true
        // Setup SKView and SKScene add add the SKView as a subview of the NSView
        // setup the skview and scene, then add the skview as a subview of the main view
        
        skview = SKView(frame: frame)
        skview?.showsFPS = true
        skview?.showsNodeCount = true
        skview?.showsPhysics = true
        skview?.showsDrawCount = true
        skview?.layer?.borderWidth = 10
        skview?.layer?.borderColor = CGColor.black
        scene = SKScene(size: frame.size)
        scene?.backgroundColor = NSColor.white
        scene?.isUserInteractionEnabled = true
        
        letterLabel.position = CGPoint(x: 75, y: frame.minY + 15)
        letterLabel.zPosition = 1
        
        letterNode.position = CGPoint(x: -45, y: frame.minY - 35)
        letterNode.fillColor = NSColor.black
        letterNode.zPosition = 1
        
        
        livesLabel.position = CGPoint(x: 185, y: frame.maxY - 45)
        livesLabel.zPosition = 1
        
        livesNode.position = CGPoint(x: -25, y: frame.maxY - 60)
        livesNode.fillColor = NSColor.black
        livesNode.zPosition = 1
        
        
        gameScoreLabel.position = CGPoint(x: 700, y: frame.maxY - 45)
        gameScoreLabel.zPosition = 1
        
        gameScoreNode.position = CGPoint(x: 600, y: frame.maxY - 60)
        gameScoreNode.fillColor = NSColor.black
        gameScoreNode.zPosition = 1
        
        lightBlueLabel.fontColor = NSColor.red
        lightBlueLabel.position = CGPoint(x: 250, y: 75)
        lightBlueLabel.zPosition = 1
        lightBlueLabel.fontName = "Arial"
        //scene?.addChild(lightBlueLabel)
        darkBlueLabel.fontColor = NSColor.red
        darkBlueLabel.position = CGPoint(x: 250, y: 75)
        darkBlueLabel.zPosition = 1
        darkBlueLabel.fontName = "Arial"
        //scene?.addChild(darkBlueLabel)
        
        // Code that sets up the textbox for letter entry
        textBox.font = NSFont(name: "Roboto", size: 36)
        textBox.textColor = NSColor.white
        textBox.maximumNumberOfLines = 1
        textBox.lineBreakMode = .byTruncatingTail
        textBox.backgroundColor = NSColor(calibratedRed: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        textBox.delegate = self
        
        
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundNode.zPosition = 2
        
        gameOverLabel.position = CGPoint(x: backgroundNode.frame.midX, y: backgroundNode.frame.midY)
        gameOverLabel.zPosition = 3
        gameOverLabel.fontColor = NSColor.black
        
        
        
        skview?.presentScene(scene)
        self.view.addSubview(skview!)
        // begin animating circles
        startGameScreen()
    }
    
    func startGameScreen(){
        scene?.addChild(startGame)
        
        // Set up the start game button. This includes text, colour, positioning etc.
        let startButton = NSButton(title: "Start Game!", target: self, action: #selector(load))
        startButton.frame = NSRect(x: (frame.midX) - 65 , y: frame.midY - 115, width: 125, height: 50)
        startButton.bezelStyle = .texturedSquare
        startButton.isBordered = false
        startButton.wantsLayer = true
        startButton.layer?.backgroundColor = NSColor(calibratedRed: 0.259, green: 0.957, blue: 0.431, alpha: 1).cgColor
        startButton.layer?.cornerRadius = 8
        
        let buttonText = NSMutableAttributedString(string: "Start Game!")
        buttonText.addAttribute(.foregroundColor, value: NSColor.black, range: NSMakeRange(0, buttonText.length))
        buttonText.addAttribute(.font, value: buttonFont, range: NSMakeRange(0, buttonText.length))
        
        startButton.attributedTitle = buttonText
        startButton.action = Selector("load")
        startButton.tag = 1
        view.addSubview(startButton)
        
        descriptionLabel.position = CGPoint(x: frame.midX, y: frame.midY - 260)
        descriptionLabel.fontName = "Arial"
        descriptionLabel.fontSize = 20
        descriptionLabel.fontColor = NSColor.black
        descriptionLabel.preferredMaxLayoutWidth = 550
        descriptionLabel.numberOfLines = 3
        descriptionLabel.verticalAlignmentMode = .baseline
        
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 10)
        titleLabel.fontSize = 50
        titleLabel.fontName = "Arial"
        titleLabel.fontColor = NSColor.black
        
        subtitleLabel.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        subtitleLabel.fontSize = 25
        subtitleLabel.fontName = "Arial"
        subtitleLabel.fontColor = NSColor.black
        
        scene?.addChild(titleLabel)
        scene?.addChild(subtitleLabel)
        scene?.addChild(descriptionLabel)
    
    }
    
    func addHUD(){
        scene?.addChild(letterNode)
        scene?.addChild(letterLabel)
        
        scene?.addChild(livesNode)
        scene?.addChild(livesLabel)
        
        scene?.addChild(gameScoreNode)
        scene?.addChild(gameScoreLabel)
        
        addedHUD = true
    }
    
    var score = 0
    @objc func load(){
        // Remove menu items
        titleLabel.removeFromParent()
        subtitleLabel.removeFromParent()
        descriptionLabel.removeFromParent()
        view.viewWithTag(1)?.removeFromSuperview()
        
        skview?.addSubview(textBox)
        //print ("Creating sprites...")
        
        if !addedHUD{
            addHUD()
        }
        
        dispatchQueue.async {
            // create an array of SKActions, and add the two defined actions for animating the circle. This is done so both the width and height change at the same time.
            var actions = Array<SKAction>()
            actions.append(self.width)
            actions.append(self.height)
            
            // create a group of SKActions from the array just defined.
            let group = SKAction.group(actions)
            
            var gameOver = false
            while !gameOver{
                
                
                if self.circleCount % 5 == 0{
                    //print("Increasing Speed!")
                    self.circleGapSpeed = self.circleGapSpeed - 500000
                    self.width.duration - 1
                    self.height.duration - 1
                    
                }
                
                // display the chosen letter with applyed attributes
                self.letterLabel.attributedText = self.attributeText(string: "Colour: ")
                
                // display the amount of lives left with applyed attributes
                self.livesLabel.attributedText = self.attributeText(string: "Lives Remaining: \(self.livesRemaining)")
                
                self.gameScoreLabel.attributedText = self.attributeText(string: "Score: \(self.score)")
                
                // create a new sprite
                var sprite = self.createSprites()
                
                let colour = self.checkColour(sprite: sprite)
                
                self.colourArray.append(colour)
                self.spriteArray.append(sprite.name ?? "yeet")
                //print (self.spriteArray.count)
                
                // set the initial position of the circle to the center of the frame.
                sprite.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.scene?.addChild(sprite)
                // run the skaction defined above, then delete the circle from the scene. This saves resources.
                sprite.run(group, completion: {
                    sprite.removeFromParent()
                    if !self.restart{
                        self.scene?.run(SKAction.playSoundFileNamed("circleBig.wav", waitForCompletion: false))
                    }
                    self.colourArray.remove(at: self.colourArray.startIndex)
                    self.spriteArray.remove(at: self.spriteArray.startIndex)
                    self.livesRemaining = self.livesRemaining - 1
                    if self.livesRemaining == 0{
                        gameOver = true
                    }
                })
                
                // a delay of 0.5 seconds to create a gap between the circles.
                usleep(UInt32(self.circleGapSpeed))
                self.circleCount = self.circleCount + 1
            }
            if gameOver{
                self.gameOverScreen()
            }
        }
    }
    
    func gameOverScreen(){
        restart = true
        textBox.isEditable = false
        textBox.isSelectable = false
        textBox.stringValue = ""
        //print ("Game Over")
        scene?.addChild(backgroundNode)
        
        gameScoreLabel.zPosition = 4
        gameScoreNode.zPosition = 4
        
        livesLabel.attributedText = attributeText(string: "Lives Remaining: \(livesRemaining)")
        
        for i in spriteArray{
            scene?.childNode(withName: i)?.removeFromParent()
        }
        
        spriteArray.removeAll()
        colourArray.removeAll()
        
        print (spriteArray.count)
        
        let restartButton = NSButton(title: "Restart!", target: self, action: #selector(reset))
        
        gameOverLabel.attributedText = attributeStartEndText(string: "Game Over!")
        
        scene?.addChild(gameOverLabel)
        
        restartButton.frame = NSRect(x: (frame.width / 2) - 50, y: frame.midY - 100, width: 100, height: 50)
        
        restartButton.bezelStyle = .texturedSquare
        restartButton.isBordered = false
        restartButton.wantsLayer = true
        restartButton.layer?.backgroundColor = NSColor(calibratedRed: 1, green: 0.514, blue: 0, alpha: 1).cgColor
        restartButton.layer?.cornerRadius = 8
        
        let startButtonText = NSMutableAttributedString(string: "Restart!")
        startButtonText.addAttribute(.foregroundColor, value: NSColor.black, range: NSMakeRange(0, startButtonText.length))
        startButtonText.addAttribute(.font, value: buttonFont, range: NSMakeRange(0, startButtonText.length))
        
        restartButton.attributedTitle = startButtonText
        restartButton.tag = 2
        backgroundNode.run(fadeToBlack, completion: {
            //print (restartButton.tag)
            self.view.addSubview(restartButton)
        })
        
    }
    
    @objc func reset(){
        backgroundNode.removeFromParent()
        gameOverLabel.removeFromParent()
        view.viewWithTag(2)?.removeFromSuperview()
        livesRemaining = 3
        circleCount = 0
        restart = false
        textBox.isEditable = true
        

        load()
    }
    
    func attributeText(string: String) -> NSMutableAttributedString{
        let attrLetter: NSMutableAttributedString = NSMutableAttributedString(string: string)
        attrLetter.addAttribute(.font, value: self.letterFont, range: NSMakeRange(0, attrLetter.length))
        attrLetter.addAttribute(.foregroundColor, value: NSColor.white, range: NSMakeRange(0, attrLetter.length))
        attrLetter.addAttribute(.strokeColor, value: NSColor.black, range: NSMakeRange(0, attrLetter.length))
        attrLetter.addAttribute(.strokeWidth, value: -3.0, range: NSMakeRange(0, attrLetter.length))
        // display the chosen letter with applyed attributes
        return attrLetter
    }
    
    func attributeStartEndText(string: String) -> NSMutableAttributedString{
        let attrLetter: NSMutableAttributedString = NSMutableAttributedString(string: string)
        attrLetter.addAttribute(.font, value: self.gameFont, range: NSMakeRange(0, attrLetter.length))
        attrLetter.addAttribute(.foregroundColor, value: NSColor.white, range: NSMakeRange(0, attrLetter.length))
        attrLetter.addAttribute(.strokeColor, value: NSColor.black, range: NSMakeRange(0, attrLetter.length))
        attrLetter.addAttribute(.strokeWidth, value: -3.0, range: NSMakeRange(0, attrLetter.length))
        // display the chosen letter with applyed attributes
        return attrLetter
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        //print(spriteArray.first)
        //print(colourArray.first)
        print (colourArray.first)
        if textBox.stringValue == colourArray.first{
            if !restart {
                scene?.run(SKAction.playSoundFileNamed("correct.wav", waitForCompletion: false))
            }
            score = score + 1
            //print ("Score \(score)")
            gameScoreLabel.attributedText = attributeText(string: "Score: \(score)")
            scene?.childNode(withName: spriteArray.first ?? "nil")?.removeFromParent()
            colourArray.remove(at: colourArray.startIndex)
            spriteArray.remove(at: spriteArray.startIndex)
            textBox.stringValue = ""
            //print ("Correct")
        } else {
            print (textBox.stringValue)
            if textBox.stringValue == "blue"{
                let colour = self.colourArray.first
                print (colour)
                
                if colour == "dark blue"{
                    self.scene?.addChild(self.darkBlueLabel)
                    let wait = SKAction.wait(forDuration: 2)
                    darkBlueLabel.run(wait) {
                        self.darkBlueLabel.removeFromParent()
                    }
                }
                else if colour == "light blue"{
                    self.scene?.addChild(self.lightBlueLabel)
                    
                    let wait = SKAction.wait(forDuration: 2)
                    lightBlueLabel.run(wait) {
                        self.lightBlueLabel.removeFromParent()
                    }
                    
                }
            }
            if !restart {
                scene?.run(SKAction.playSoundFileNamed("incorrect.wav", waitForCompletion: false))
            }
        }
    }
    
    // Checks the colour of the current circle being guessed
    func checkColour(sprite: SKSpriteNode) -> String{
        var spriteColour = String()
        if sprite.name?.contains("Red") ?? false{
            //print ("Red")
            spriteColour = "red"
        }
        else if sprite.name?.contains("Orange")  ?? false{
            //print ("Orange")
            spriteColour = "orange"
        }
        else if sprite.name?.contains("Purple")  ?? false{
            //print ("Purple")
            spriteColour = "purple"
        }
        else if sprite.name?.contains("Pink")  ?? false{
            //print ("Pink")
            spriteColour = "pink"
        }
        else if sprite.name?.contains("LightBlue")  ?? false{
            //print ("LightBlue")
            spriteColour = "light blue"
        }
        else if sprite.name?.contains("DarkBlue")  ?? false{
            //print ("DarkBlue")
            spriteColour = "dark blue"
        }
        else if sprite.name?.contains("Green")  ?? false{
            //print ("Green")
            spriteColour = "green"
        }
        else if sprite.name?.contains("Yellow")  ?? false{
            //print ("Yellow")
            spriteColour = "yellow"
        }
        else if sprite.name?.contains("circle.png")  ?? false{
            //print ("Black")
            spriteColour = "black"
        }
        else if sprite.name?.contains("Brown")  ?? false{
            //print ("Brown")
            spriteColour = "brown"
        }
        return spriteColour
    }
    
    // set nodeName to 0. This number is used in the unique name for every circle.
    var nodeName = 0

    func createSprites()->SKSpriteNode{
        let randomImage = circleColours.randomElement()
        let sprite = SKSpriteNode(imageNamed: randomImage ?? "circle.png")
        sprite.name = "\(randomImage!)\(nodeName)"
        sprite.isUserInteractionEnabled = true
        sprite.size = CGSize(width: 10, height: 10)
        sprite.position = CGPoint(x: frame.midX, y: frame.midY)
        nodeName = nodeName + 1
        return sprite
    }
}

let vc = view()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = vc

