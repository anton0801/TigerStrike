import Foundation
import SpriteKit
import SwiftUI

class StrikeGameScene: SKScene {
    
    var level: LevelModel! {
        didSet {
        }
    }
    
    init(size: CGSize, level: LevelModel) {
        // self.level = level
        super.init(size: size)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var lamps = ["lamp_1", "lamp_2", "lamp_3", "lamp_4"]
    private var rulesContent = ["rules_1","rules_2","rules_3","rules_4","rules_5"]
    private var rulesCurrentIndex = 0 {
        didSet {
            let newTexture = SKTexture(imageNamed: rulesContent[rulesCurrentIndex])
            rulesContentNode.texture = newTexture
        }
    }
    
    private var objectiveLamp = Int.random(in: 0...3) {
        didSet {
            let newTexture = SKTexture(imageNamed: lamps[objectiveLamp])
            objectiveLampNode.texture = newTexture
        }
    }
    private var objectiveCollected = 0 {
        didSet {
            if objectiveCollected == level.ballsObjectiveCount {
                NotificationCenter.default.post(name: Notification.Name("WIN_GAME"), object: nil, userInfo: nil)
                isPaused = true
                gameStarted = false
            }
        }
    }
    private var lampsCollected = 0
    
    private var rulesTitle: SKSpriteNode!
    private var rulesContentNode: SKSpriteNode!
    private var rulesTiger: SKSpriteNode!
    
    private var pauseBtn: SKSpriteNode!
    private var addTimerBonus: SKSpriteNode!
    private var restartBtn: SKSpriteNode!
    
    private var levelsLabelBack: SKSpriteNode!
    private var levelLabel: SKLabelNode!
    
    private var timeBack: SKSpriteNode!
    private var timeLabel: SKLabelNode!
    
    private var gameTime = 50 {
        didSet {
            timeLabel.text = formatSecondsToMinutesSeconds(seconds: gameTime)
            if gameTime == 0 {
                NotificationCenter.default.post(name: Notification.Name("LOSE_GAME"), object: nil, userInfo: nil)
                isPaused = true
                gameStarted = false
            }
        }
    }
    private var gameTimer: Timer = Timer()
    private var lampsTimer: Timer = Timer()
    private var gameStarted = false
    
    private var credits = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            creditsLabel.text = "\(credits)"
            UserDefaults.standard.set(credits, forKey: "credits")
        }
    }
    
    private var lives = UserDefaults.standard.integer(forKey: "lives") {
        didSet {
            livesLabel.text = "\(lives)"
            UserDefaults.standard.set(lives, forKey: "lives")
        }
    }
    
    private var creditsLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    private var timeBonusCountLabel: SKLabelNode!
    
    private var timeBonusCount = UserDefaults.standard.integer(forKey: "timebonus") {
        didSet {
            timeBonusCountLabel.text = "\(timeBonusCount)"
            UserDefaults.standard.set(timeBonusCount, forKey: "timebonus")
        }
    }
    
    private var objectiveLampNode: SKSpriteNode!
    
    func formatSecondsToMinutesSeconds(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        if let formattedString = formatter.string(from: TimeInterval(seconds)) {
            return formattedString
        } else {
            return "00:00"
        }
    }

    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1335)
        makeBackGame()
        makeObjectiveLamp()
        makeTimeLabel()
        makeUIItems()
        
        if level == nil {
            level = LevelModel(levelId: "lvl_1", num: 1, eachBallsChangeObjectiveBall: 3, ballsObjectiveCount: 20)
        }
        
        gameTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimerFunc), userInfo: nil, repeats: true)
        
        if !UserDefaults.standard.bool(forKey: "showed_rules_game") {
            rulesMake()
            UserDefaults.standard.set(true, forKey: "showed_rules_game")
        } else {
            startGame()
        }
        
        makeLevelLabel()
    }
    
    private func startGame() {
        gameStarted = true
        lampsTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(createLamp), userInfo: nil, repeats: true)
    }
    
    func continuePlay() {
        isPaused = false
        gameStarted = true
    }
    
    @objc private func createLamp() {
        if !isPaused && gameStarted {
            let xPos = Int.random(in: 100...700)
            let lampItem = lamps.randomElement() ?? "lamp_1"
            let lamp = SKSpriteNode(imageNamed: lampItem)
            lamp.position = CGPoint(x: xPos, y: 280)
            lamp.size = CGSize(width: 130, height: 130)
            lamp.name = lampItem
            addChild(lamp)
            
            let actionMove = SKAction.move(to: CGPoint(x: xPos, y: Int(size.height) - 450), duration: 5.0 - (0.1 * Double(level.num)))
            let actionFadeOut = SKAction.fadeOut(withDuration: 0.1)
            let sequence = SKAction.sequence([actionMove, actionFadeOut])
            lamp.run(sequence) {
                lamp.removeFromParent()
            }
        }
    }
    
    private func makeUIItems() {
        let tigerSticker = SKSpriteNode(imageNamed: "tiger_2")
        tigerSticker.position = CGPoint(x: size.width / 2, y: 90)
        tigerSticker.size = CGSize(width: 150, height: 180)
        addChild(tigerSticker)
        
        pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: size.width / 2, y: 50)
        pauseBtn.size = CGSize(width: 140, height: 70)
        addChild(pauseBtn)
        
        addTimerBonus = SKSpriteNode(imageNamed: "add_time_booster")
        addTimerBonus.position = CGPoint(x: size.width / 2 - 190, y: 130)
        addTimerBonus.size = CGSize(width: 180, height: 80)
        addChild(addTimerBonus)
        
        let timerBonusBg = SKSpriteNode(imageNamed: "level_list_item_bg")
        timerBonusBg.position = CGPoint(x: size.width / 2 - 260, y: 110)
        timerBonusBg.size = CGSize(width: 50, height: 35)
        addChild(timerBonusBg)
        
        timeBonusCountLabel = SKLabelNode(text: "\(timeBonusCount)")
        timeBonusCountLabel.position = CGPoint(x: size.width / 2 - 260, y: 103)
        timeBonusCountLabel.fontName = "Kung-FuMaster3DItalic"
        timeBonusCountLabel.fontSize = 24
        timeBonusCountLabel.fontColor = .white
        addChild(timeBonusCountLabel)
        
        restartBtn = SKSpriteNode(imageNamed: "restart_btn")
        restartBtn.position = CGPoint(x: size.width / 2 + 190, y: 130)
        restartBtn.size = CGSize(width: 180, height: 80)
        addChild(restartBtn)
        
        let coinsBg = SKSpriteNode(imageNamed: "game_info_bg")
        coinsBg.position = CGPoint(x: 120, y: 45)
        coinsBg.size = CGSize(width: 180, height: 80)
        addChild(coinsBg)
        
        creditsLabel = SKLabelNode(text: "\(credits)")
        creditsLabel.position = CGPoint(x: 90, y: 35)
        creditsLabel.fontName = "Kung-FuMaster3DItalic"
        creditsLabel.fontSize = 32
        creditsLabel.fontColor = .white
        addChild(creditsLabel)
        
        let coin = SKSpriteNode(imageNamed: "point")
        coin.position = CGPoint(x: 160, y: 47)
        addChild(coin)
        
        let livesBg = SKSpriteNode(imageNamed: "game_info_bg")
        livesBg.position = CGPoint(x: size.width - 120, y: 45)
        livesBg.size = CGSize(width: 180, height: 80)
        addChild(livesBg)
        
        livesLabel = SKLabelNode(text: "\(lives)")
        livesLabel.position = CGPoint(x: size.width - 150, y: 35)
        livesLabel.fontName = "Kung-FuMaster3DItalic"
        livesLabel.fontSize = 32
        livesLabel.fontColor = .white
        addChild(livesLabel)
        
        let heart = SKSpriteNode(imageNamed: "heart")
        heart.position = CGPoint(x: size.width - 80, y: 47)
        heart.size = CGSize(width: 50, height: 40)
        addChild(heart)
    }
    
    @objc private func gameTimerFunc() {
        if gameStarted && !isPaused {
            gameTime -= 1
        }
    }
    
    private func makeTimeLabel() {
        timeBack = SKSpriteNode(imageNamed: "name_bg")
        timeBack.position = CGPoint(x: size.width / 2, y: size.height - 380)
        addChild(timeBack)
        
        timeLabel = SKLabelNode(text: "00:30")
        timeLabel.fontName = "Kung-FuMaster3DItalic"
        timeLabel.fontSize = 32
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: size.width / 2, y: size.height - 390)
        addChild(timeLabel)
    }
    
    private func makeLevelLabel() {
        levelsLabelBack = SKSpriteNode(imageNamed: "name_bg")
        levelsLabelBack.position = CGPoint(x: size.width / 2, y: size.height - 150)
        levelsLabelBack.size = CGSize(width: 350, height: 100)
        addChild(levelsLabelBack)
        
        levelLabel = SKLabelNode(text: "LEVEL \(level.num)")
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height - 170)
        levelLabel.fontName = "Kung-FuMaster3DItalic"
        levelLabel.fontSize = 62
        levelLabel.fontColor = .white
        addChild(levelLabel)
    }
    
    private func makeObjectiveLamp() {
        let objectiveLampBg = SKSpriteNode(imageNamed: "lamp_bg")
        objectiveLampBg.position = CGPoint(x: size.width / 2, y: size.height - 280)
        objectiveLampBg.size = CGSize(width: 150, height: 130)
        addChild(objectiveLampBg)
        
        objectiveLampNode = SKSpriteNode(imageNamed: lamps[objectiveLamp])
        objectiveLampNode.position = CGPoint(x: size.width / 2, y: size.height - 280)
        objectiveLampNode.size = CGSize(width: 70, height: 70)
        addChild(objectiveLampNode)
    }
    
    private func makeBackGame() {
        let backNode = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "chart") ?? "chart_base")
        backNode.size = size
        backNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backNode)
        
        let bottomGame = SKSpriteNode(imageNamed: "store_bottom")
        bottomGame.size = CGSize(width: size.width, height: 250)
        bottomGame.position = CGPoint(x: size.width / 2, y: 125)
        addChild(bottomGame)
        
        if UserDefaults.standard.bool(forKey: "soundsEnabledInApp") {
            let backMusicNode = SKAudioNode(fileNamed: "game_fon")
            addChild(backMusicNode)
        }
    }
    
    private func rulesMake() {
        rulesTitle = SKSpriteNode(imageNamed: "rules_title")
        rulesTitle.position = CGPoint(x: size.width / 2, y: size.height - 150)
        rulesTitle.size = CGSize(width: 350, height: 100)
        addChild(rulesTitle)
        
        rulesContentNode = SKSpriteNode(imageNamed: rulesContent[rulesCurrentIndex])
        rulesContentNode.size = CGSize(width: 450, height: 240)
        rulesContentNode.position = CGPoint(x: size.width / 2 + 150, y: size.height / 2 - 100)
        addChild(rulesContentNode)
        
        rulesTiger = SKSpriteNode(imageNamed: "tiger")
        rulesTiger.position = CGPoint(x: size.width / 2 - 270, y: size.height / 2 - 300)
        rulesTiger.size = CGSize(width: 220, height: 280)
        addChild(rulesTiger)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if rulesTitle != nil {
            if rulesCurrentIndex < rulesContent.count - 1 {
                rulesCurrentIndex += 1
            } else {
                let actionFade = SKAction.fadeOut(withDuration: 0.3)
                rulesTitle.run(actionFade) {
                    self.rulesTitle.removeFromParent()
                    self.rulesTitle = nil
                }
                rulesContentNode.run(actionFade) {
                    self.rulesContentNode.removeFromParent()
                }
                rulesTiger.run(actionFade) {
                    self.rulesTiger.removeFromParent()
                }
                startGame()
            }
        }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        guard !nodes(at: location).contains(pauseBtn) else {
            pauseGame()
            return
        }
        
        guard !nodes(at: location).contains(restartBtn) else {
            NotificationCenter.default.post(name: Notification.Name("restartGame"), object: nil, userInfo: nil)
            return
        }
        
        guard !nodes(at: location).contains(addTimerBonus) else {
            if timeBonusCount > 0 {
                gameTime += 30
                timeBonusCount -= 1
            }
            return
        }
        
        for node in nodes(at: location) {
            if node.name?.contains("lamp") == true {
                let lampType = Int(node.name!.components(separatedBy: "_")[1])
                lampsCollected += 1
                if lampType == objectiveLamp {
                    objectiveCollected += 1
                }
                
                if (lampsCollected % level.eachBallsChangeObjectiveBall) == 0 {
                    objectiveLamp = Int.random(in: 0...3)
                }
                
                node.removeFromParent()
            }
        }
    }
    
    private func pauseGame() {
        NotificationCenter.default.post(name: Notification.Name("pauseGame"), object: nil, userInfo: nil)
        isPaused = true
    }
    
    func restartGame() -> StrikeGameScene {
        let newStrikeScene = StrikeGameScene(size: CGSize(width: 750, height: 1335), level: level)
        // newStrikeScene.level = level
        view?.presentScene(newStrikeScene)
        return newStrikeScene
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: StrikeGameScene(size: CGSize(width: 750, height: 1335), level: LevelModel(levelId: "lvl_1", num: 1, eachBallsChangeObjectiveBall: 3, ballsObjectiveCount: 20)))
            .ignoresSafeArea()
    }
}
